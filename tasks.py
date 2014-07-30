import os
import time
import copy
import xml.etree.ElementTree as ET

if 'AWS_ACCESS_KEY' in os.environ:
    os.environ['AWS_ACCESS_KEY_ID'] = os.environ['AWS_ACCESS_KEY']

if 'AWS_SECRET_KEY' in os.environ:
    os.environ['AWS_SECRET_ACCESS_KEY'] = os.environ['AWS_SECRET_KEY']

from invoke import task

import boto
import boto.ec2.autoscale

# boto.set_stream_logger('boto')

@task
def cleanup_images(region='us-east-1', keep=3):
    "Destroy old AMIs"
    ec2 = boto.ec2.connect_to_region(region)
    images = find_images(ec2)
    images_to_destroy = images[:-keep]

    if not images_to_destroy:
        print "No images to destroy"
        return

    print "Images to destroy:"
    for image in images_to_destroy:
        print "%s: %s" % (image.id, image.name)

    try:
        raw_input("Press Enter to continue or Ctrl-C to abort...\n")
    except KeyboardInterrupt:
        return

    for image in images_to_destroy:
        _destroy_image(image)

    print "Done"

@task
def list_images(region='us-east-1'):
    ec2 = boto.ec2.connect_to_region(region)
    images = find_images(ec2)
    for image in images:
        print "%s: %s" % (image.id, image.name)


@task
def destroy_image(ami, region='us-east-1'):
    ec2 = boto.ec2.connect_to_region(region)

    print "Getting AMI metadata"
    image = ec2.get_image(ami)
    if image is None:
        print "Image not found: %s" % ami
        return

    _destroy_image(image)

    print "Done"

@task
def launch_instance(ami, region='us-east-1'):
    ec2 = boto.ec2.connect_to_region(region)
    reservation = ec2.run_instances(
        ami,
        key_name='proxxy',
        instance_type='m3.xlarge',
        security_groups=['proxxy-test'])

    print "Reservation: %s" % reservation

    instance = reservation.instances[0]
    print "Instance: %s" % instance

    while instance.state != 'running':
        time.sleep(5)
        instance.update() # Updates Instance metadata
        print "Instance state: %s" % (instance.state)

    print "You can now SSH into this server with ubuntu@%s" % (instance.ip_address)

@task
def destroy_instance(instance, region='us-east-1'):
    ec2 = boto.ec2.connect_to_region(region)
    result = ec2.terminate_instances(instance_ids=[instance])
    print "Result: %s" % result

@task
def update_asg(ami, name='proxxy', region='us-east-1'):
    if ami is None:
        print "AMI not specified"
        exit(1)

    ec2 = boto.ec2.connect_to_region(region)
    autoscale = boto.ec2.autoscale.connect_to_region(region)

    # get AMI metadata
    ami = ec2.get_all_images(image_ids=[ami])[0]
    new_launch_config_name = 'proxxy-'+ami.id

    # get autoscaling group
    autoscale_group = autoscale.get_all_groups(names=[name])[0]

    # get old launch configuration
    old_launch_config_name = autoscale_group.launch_config_name
    if old_launch_config_name == new_launch_config_name:
        print "Autoscale Group '%s' already uses launch config '%s'" % (name, new_launch_config_name)
        exit(0)

    old_launch_config = autoscale.get_all_launch_configurations(names=[old_launch_config_name])[0]
    print "Old Launch Configuration: %s" % old_launch_config

    # create new launch configuration based on the old one
    new_launch_config = copy.copy(old_launch_config)
    new_launch_config.name = new_launch_config_name
    new_launch_config.image_id = ami.id
    new_launch_config.instance_monitoring = None
    new_launch_config.block_device_mappings = None
    autoscale.create_launch_configuration(new_launch_config)
    print "New Launch Configuration: %s" % new_launch_config

    # switch autoscaling group from old LC to new LC
    autoscale_group.launch_config_name = new_launch_config_name
    autoscale_group.update()

    # delete old launch configuration
    old_launch_config.delete();

    print "Done"

@task
def rotate_asg(name='proxxy', region='us-east-1', min_healthy_instances=2):
    ec2 = boto.ec2.connect_to_region(region)
    autoscale = boto.ec2.autoscale.connect_to_region(region)

    autoscale_group = autoscale.get_all_groups(names=[name])[0]
    old_instances = copy.copy(autoscale_group.instances)

    original_desired_capacity = autoscale_group.desired_capacity
    if original_desired_capacity < min_healthy_instances:
        print "Temporarily increasing desired capacity to %s" % min_healthy_instances
        autoscale_group.desired_capacity = min_healthy_instances
        autoscale_group.update()

    wait_for_healthy_instances(autoscale, name, min_healthy_instances)

    for old_instance in old_instances:
        print "Terminating instance %s" % old_instance.instance_id
        autoscale.terminate_instance(old_instance.instance_id, decrement_capacity=False)
        time.sleep(5)
        wait_for_healthy_instances(autoscale, name, min_healthy_instances)

    if original_desired_capacity < min_healthy_instances:
        print "Decreasing desired capacity back to %s" % original_desired_capacity
        autoscale_group.desired_capacity = original_desired_capacity
        autoscale_group.update()

    print "Done"

def wait_for_healthy_instances(autoscale, asg_name, min_count = 2):
    while True:
        asg = autoscale.get_all_groups(names=[asg_name])[0]
        print "Instances: %s" % asg.instances

        healthy_instances = [instance for instance in asg.instances if instance.lifecycle_state == 'InService']
        print "Healthy Instances: %s" % healthy_instances

        count = len(healthy_instances)
        if count < min_count:
            print "Need at least {} instances in service to continue, got {}, waiting...".format(min_count, count)
            time.sleep(30)
            asg.update();
        else:
            break

def delete_bundle(manifest_location):
    s3 = boto.connect_s3()

    bucket_name, manifest_path = manifest_location.split('/', 1)
    bucket = s3.get_bucket(bucket_name, validate=False)
    if bucket is None:
        print "No bucket found: %s" % bucket_name
        return

    print "Downloading AMI manifest: %s" % manifest_path
    manifest_key = bucket.get_key(manifest_path)
    if manifest_key is None:
        print "WARNING: manifest not found, AMI bundle is probably already delete"
        return

    parts_prefix = manifest_path.rsplit('/', 1)[0]
    manifest_raw = manifest_key.get_contents_as_string()

    to_delete = []
    manifest = ET.fromstring(manifest_raw)
    for part in manifest.findall('./image/parts/part/filename'):
        part_path = parts_prefix + '/' + part.text
        to_delete.append(part_path)

    print "Deleting %d bundle parts" % len(to_delete)
    to_delete.append(manifest_key.name)
    return bucket.delete_keys(to_delete)

def find_images(ec2):
    filters = {
        'name': '*proxxy*'
    }
    images = ec2.get_all_images(filters=filters)
    images = sorted(images, key=lambda image: image.name)
    return images

def _destroy_image(image):
    print "Destroying image: %s" % image.id
    if image.root_device_type == 'instance-store':
        print "Deleting AMI bundle: %s" % image.location
        multi_delete_result = delete_bundle(image.location)
        if multi_delete_result.errors:
            "Bundle deleted, with errors: %s" % vars(multi_delete_result)

        print "Deregistering AMI"
        image.deregister()
    else:
        print "Unsupported root device type: %s" % image.root_device_type
        return
