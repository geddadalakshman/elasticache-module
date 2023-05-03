resource "aws_elasticache_cluster" "main" {
  cluster_id           = "${var.env}-redis"
  engine               = var.engine
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = "default.redis3.2"
  engine_version       = var.engine_version
  db_subnet_group_name = aws_docdb_subnet_group.main.name
}


resource "aws_security_group" "main" {
  name        = "elasticache-${var.env}"
  description = "elasticache-${var.env}"
  vpc_id      = var.vpc_id

  ingress {
    description = "ELASTICACHE"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = var.allow_subnets
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.tags,
    { Name = "elasticache-${var.env}" }
  )
}

resource "aws_docdb_subnet_group" "main" {
  name       = "${var.env}-redis-subnet_group"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-subnet-group"
    },
  )
}

output "redis" {
  value = aws_elasticache_cluster.main
}

resource "aws_ssm_parameter" "elasticache_endpoint" {
  name  = "${var.env}.elasticache.endpoint"
  type  = "String"
  value = aws_elasticache_cluster.main.cache_nodes[0].address
}




