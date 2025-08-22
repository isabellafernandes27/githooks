terraform{
required_version=">=1.3.0"
}

resource "null_resource""bad"{
triggers={always_run=timestamp()
}}
