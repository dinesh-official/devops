```txt
terraform {
  required_version = ""   => Required version 
  required _providers {
    aws= {
      source = "hashicErp/aws"
      version = "3.50.0"
    }
  }
}

---
Required version
1) only allows if the mention vesion is same as the install version


patch version eg
~> 1.1.0  1.1.0 1.1.1 1.1.15 1.1.66

minor version eg
~> 1.2  1.3 1.5 1.7 1.66

Symantic Versioning
-------------------
1.5.6

1 -> major version
5 -> minor version
6 -> patch version



```

<img width="685" height="471" alt="image" src="https://github.com/user-attachments/assets/6fc6228f-0ae5-4bcc-a030-1de3c437dc58" />


```txt
Multiple provider
-----------------

terraform {
  required_version = "~> 1.11.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "'~> 4.0"
    }
  }
}

# Provider-1 for Mumbai (Default Provider)
provider "aws" {
  region = "ap-south-1"
  access_key = "userAcc1-my-access-key"
  secret_key = "userAcc1-my-secret-key"
}

# Provider-2 for Singapore
provider "aws" {
  region = "ap-southeast-1"
  access_key = "userAcc2-my-access-key"
  secret_key = "userAcc2-my-secret-key"
  alias= "sing"
}

# Resource Block to Create VPC in ap-south-1 which uses default provider
resource "aws_vpc" "Mumbai-VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Mumbai-VPC"
  }
}

# Resource Block to Create VPC in ap-southeast-1 which uses default provider
resource "aws_vpc" "Sing-VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  provider = aws.sing             # Here vwe are refreing the provider for singapore 

  tags = {
    Name = "Sing-VPC"
  }
}
```

```txt
Statefile
---------
* It keep all the changes as log


Immutable
---------
* minor change it will edit and if major changes it will delete it and re-create it

Meta-Arguments
-------------------------
* Count

# meta-argument
resource "aws_vpc" "my-vpc-1" {
  cidr_block = "10.0.0.0/16"
  count = 2
tags = {
  "Name" = "terra-vpc-mumbai-${count.index}"
  }
}


```

* For Each map
<img width="743" height="464" alt="image" src="https://github.com/user-attachments/assets/e0023f3e-fd14-4b5b-993e-9c4b7321efb4" />

* For Each set
<img width="576" height="247" alt="image" src="https://github.com/user-attachments/assets/3b67c40f-a6ad-44a0-b7e9-80062186531e" />

```
Lifecycle
---------
* Create Before Destroy  => if true it will create an new resorce after delete && if it is false it will first create an resorce and after it will delete
* Prevent Destroy => it prevents from the resorce destroy
* Ignore changes => it prevent or ignore the change which are mentioned in the tf code 
* Depends On => it will make the order only the mentiond resorce is create after it create the resorce it depends on the other resorce 
```
<img width="705" height="267" alt="image" src="https://github.com/user-attachments/assets/cdda0fd4-25fa-485d-8412-80e42c93b570" />

<img width="732" height="235" alt="image" src="https://github.com/user-attachments/assets/b8da0455-2522-4edf-9779-60c45e2e76ff" />
<img width="707" height="281" alt="image" src="https://github.com/user-attachments/assets/a7d5a13a-ce22-4a27-8cdd-44944c1f65a8" />


<img width="1016" height="288" alt="image" src="https://github.com/user-attachments/assets/50bdeb28-d7cd-423c-9662-e4ab90a12a7f" />

---


```
Variables Basic
Variables when prompted => get the input on executon through terminal if deafult value is not provided 
Variables override with ENV


ELI 5
ENV VAR 7
Variables -» default 1
if no default then it will ask for Input

```



