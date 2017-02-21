
module "single_lookup" {
  source = "../"

  keys           = "test1"
  map_key_list   = "test1,test2,test3"
  map_value_list = "value1,value2,value3"
}

resource "null_resource" "it_should_extract_single_value" {
  provisioner "local-exec" {
    command = <<EOF
      echo "${module.single_lookup.values} should eq value1"
      test "${module.single_lookup.values}" = "value1"
    EOF
  }
}


module "multi_lookup" {
  source = "../"

  keys           = "test1,test3"
  map_key_list   = "test1,test2,test3"
  map_value_list = "value1,value2,value3"
}

resource "null_resource" "it_should_extract_multiple_values" {
  provisioner "local-exec" {
    command = <<EOF
      echo "${module.multi_lookup.values} should eq value1,value3"
      test "${module.multi_lookup.values}" = "value1,value3"
    EOF
  }
}
