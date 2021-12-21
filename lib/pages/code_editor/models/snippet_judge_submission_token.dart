class StatusSubmissionToken {
  final int id;
  final String description;

  const StatusSubmissionToken({required this.id, required this.description});

  static StatusSubmissionToken createAStatusFromJSON(Map<String, dynamic> data) {
    return StatusSubmissionToken(
      id: data["id"],
      description: data["description"],
    );
  }
}

class SnippetJudgeSubmissionToken {
  final String? compileOutput;
  final String? memory;
  final String? message;
  final StatusSubmissionToken status;
  final String? stderr;
  final String? stdout;
  final String? time;
  final String token;

  const SnippetJudgeSubmissionToken({
    this.compileOutput,
    this.memory,
    this.message,
    required this.status,
    this.stderr,
    this.stdout,
    this.time,
    required this.token,
  });

  static SnippetJudgeSubmissionToken createASnippetJudgeSubmissionFromJSON(Map<String, dynamic> data) {
    return SnippetJudgeSubmissionToken(
      compileOutput: data["compile_output"],
      memory: data["memory"],
      message: data["message"],
      status: StatusSubmissionToken.createAStatusFromJSON(data["status"]),
      stderr: data["stderr"],
      stdout: data["stdout"],
      time: data["time"],
      token: data["token"],
    );
  }
}
