resource "aws_elasticache_cluster" "main" {
  cluster_id           = "${var.env}-redis"
  engine               = var.engine
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = "default.redis3.2"
  engine_version       = var.engine_version
  db_subnet_group_name = aws_docdb_subnet_group.main.name
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



