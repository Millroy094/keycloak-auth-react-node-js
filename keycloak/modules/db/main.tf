resource "aws_db_instance" "keycloak_db" {
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "keycloak"
  username               = "keycloak"
  password               = "keycloak"
  skip_final_snapshot    = true
  db_subnet_group_name   = var.keycloak_db_subnet_group.name
  vpc_security_group_ids = [var.keycloak_db_sg.id]
  tags = {
    Name = "Keycloak DB"
  }
}
