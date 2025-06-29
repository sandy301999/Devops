variable region{
    default = "us-east-1"
}
variable zone1{
    default= "us-east-1"
}
variable amiID {
    type = map 
    default = {
        us-east-1 = "ami-09115b7bffbe3c5e4"
        us-east-2 = "ami-06cb4d48053a9622f"
    }
  
}