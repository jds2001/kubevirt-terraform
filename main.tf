terraform {
  required_providers {
    kubernetes-alpha = {
      source = "hashicorp/kubernetes-alpha"
      version = "0.4.1"
    }
  }
}

provider "kubernetes-alpha" {
  # Configuration options
  config_path = "/home/jstanley/.kube/config"
}


resource "kubernetes_manifest" "testvm" {
  provider = kubernetes-alpha
  manifest =  {
  "apiVersion" = "kubevirt.io/v1"
  "kind" = "VirtualMachine"
  "metadata" = {
    "name" = "testvm"
    "namespace" = "default"
  }
  "spec" = {
    "running" = false
    "template" = {
      "metadata" = {
        "labels" = {
          "kubevirt.io/domain" = "testvm"
          "kubevirt.io/size" = "small"
        }
      }
      "spec" = {
        "domain" = {
          "devices" = {
            "disks" = [
              {
                "disk" = {
                  "bus" = "virtio"
                }
                "name" = "containerdisk"
              },
              {
                "disk" = {
                  "bus" = "virtio"
                }
                "name" = "cloudinitdisk"
              },
            ]
            "interfaces" = [
              {
                "bridge" = {}
                "name" = "default"
              },
            ]
          }
          "machine" = {
            "type" = "q35"
          }
          "resources" = {
            "requests" = {
              "memory" = "64M"
            }
          }
        }
        "networks" = [
          {
            "name" = "default"
            "pod" = {}
          },
        ]
        "volumes" = [
          {
            "containerDisk" = {
              "image" = "quay.io/kubevirt/cirros-container-disk-demo"
            }
            "name" = "containerdisk"
          },
          {
            "cloudInitNoCloud" = {
              "userDataBase64" = "SGkuXG4="
            }
            "name" = "cloudinitdisk"
          },
        ]
      }
    }
  }
}
}
