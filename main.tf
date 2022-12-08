terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "4.100.0"
    }
  }
}
provider "oci"  {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

#Step-1 Create Root Compartment
resource "oci_identity_compartment" "my-root_compartment" {
    compartment_id = var.compartment_id
    description = "This is a Root Compartment"
    name = "My_Root_compartment"
}

#Step-2 Create Child Compartment
resource "oci_identity_compartment" "my-test_compartment" {
    #Required
    compartment_id = oci_identity_compartment.my-root_compartment.id
    description = "This compartment is for testing"
    name = "My_compartment"
}

#Step-3 Create DRG 
resource "oci_core_drg" "my-test_drg" {
    #Required
    compartment_id = oci_identity_compartment.my-test_compartment.id
    display_name = var.drg_display_name
}

#Step-4 Create VCN
resource "oci_core_vcn" "my-test_vcn" {
    #Required
    compartment_id = oci_identity_compartment.my-test_compartment.id
    cidr_blocks = var.vcn_cidr_blocks
    display_name = var.vcn_display_name
}

#Step-5 Connect VCN with DRG
resource "oci_core_drg_attachment" "drg_to_vcn_attachment" {
    #Required
    drg_id = oci_core_drg.my-test_drg.id
    vcn_id = oci_core_vcn.my-test_vcn.id
}

##Step-6 Create Subnet for VCN
resource "oci_core_subnet" "my-test_subnet" {
    #Required
    cidr_block = var.subnet_cidr_block
    compartment_id = oci_identity_compartment.my-test_compartment.id
    vcn_id = oci_core_vcn.my-test_vcn.id
}

#resource "oci_core_instance" "test_instance" {
    #Required
    #availability_domain = var.availability_domain
    #compartment_id = oci_identity_compartment.my-test_compartment.id
    #shape = "VM.Standard.E2.1.Micro"
    #source_details {
        #Required
        #source_id = oci_core_image.test_image.id
        #source_type = "image"
#}
#}

#resource "oci_core_image" "test_image" {
    #Required
    #compartment_id = oci_identity_compartment.my-test_compartment.id
    #instance_id = oci_core_instance.test_instance.id
#}

#resource "oci_core_drg" "test_drg" {
    #Required
    #compartment_id = var.compartment_id
#}
#}

