final class Request {
  public dict<string, mixed> $query;
  public dict<string, mixed> $body;

  public function __construct(
    dict<string, mixed> $query, 
    dict<string, mixed> $body
  ) {
    $this->query = $query;
    $this->body = $body;
  }
}