class Agent {
  final String id; // internal unique id
  final String name; // Agent Name
  final String agentId; // business-facing Agent ID/code
  final String password; // plain for demo; do not store plaintext in production
  final String? avatar; // optional avatar data/url

  const Agent({required this.id, required this.name, required this.agentId, required this.password, this.avatar});
}

