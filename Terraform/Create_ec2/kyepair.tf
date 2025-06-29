#Create a key pair in git using : ssh-keygen
#Once done, copy the public key and paste in the cmd
	

resource "aws_key_pair" "sample-key" {
  key_name   = "dove-key-hehe"
  public_key = "ssh-ed25519 <KeyValue>"
}

