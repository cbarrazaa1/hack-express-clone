final class Response {
  public function __construct() {}

  public function status(int $code): Response {
    http_response_code($code);
    return $this;
  }

  public function json(dict<string, mixed> $data): void {
    header('Content-Type: application/json');
    echo json_encode($data);
  }
}