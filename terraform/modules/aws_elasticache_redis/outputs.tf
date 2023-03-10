output "cache_nodes" {
  value = aws_elasticache_cluster.elasticache_redis.cache_nodes[0].address
}

