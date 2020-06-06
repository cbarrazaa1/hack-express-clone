use namespace HH\Lib\Str;
use namespace HH\Lib\C;
use namespace HH\Lib\Dict;
use namespace HH\Lib\Vec;
type RequestHandler = (function(Request, Response): mixed);

final class Server {
  private dict<string, dict<string, RequestHandler>> $routes;
  private string $method;
  private dict<string, mixed> $query;
  private dict<string, mixed> $body;
  private string $path;
  
  public function __construct() {
    $this->routes = dict[];
    $this->path = Str\split($_SERVER['REQUEST_URI'], '?')[0];
    $this->path = $this->parse_path($this->path);
    $this->method = $_SERVER['REQUEST_METHOD'];

    // convert _GET from PHP array to Hack dict
    $query = dict[];
    foreach ($_GET as $key => $value) {
      $query[$key] = $value;
    }

    // convert json body from PHP array to Hack dict
    $body = dict[];
    $json = json_decode(file_get_contents('php://input', TRUE));
    if ($json is nonnull) {
      foreach ($json as $key => $value) {
        $body[$key] = $value;
      }
    }

    $this->query = $query;
    $this->body = $body;
  }

  private function parse_path(string $path): string {
    $path = Str\replace($path, 'index.hack', '');
    if (Str\length($path) > 1) {
      $path = Str\splice($path, '', 1, 1);
    }

    return $path;
  }

  public function process_request(): void {
    $method_handlers = $this->routes[$this->method];

    foreach ($method_handlers as $route => $handler) {
      if (Str\compare($this->path, $route) === 0) {
        $req = new Request($this->query, $this->body);
        $res = new Response();
        $handler($req, $res);
      }
    }
  }

  public function get(string $route, RequestHandler $handler): void {
    if (!C\contains_key($this->routes, 'GET')) {
      $this->routes['GET'] = dict[];
    }

    $this->routes['GET'][$route] = $handler;
  }

  public function post(string $route, RequestHandler $handler): void {
    if (!C\contains_key($this->routes, 'POST')) {
      $this->routes['POST'] = dict[];
    }

    $this->routes['POST'][$route] = $handler;
  }

  public function put(string $route, RequestHandler $handler): void {
    if (!C\contains_key($this->routes, 'PUT')) {
      $this->routes['PUT'] = dict[];
    }

    $this->routes['PUT'][$route] = $handler;
  }

  public function delete(string $route, RequestHandler $handler): void {
    if (!C\contains_key($this->routes, 'DELETE')) {
      $this->routes['DELETE'] = dict[];
    }

    $this->routes['DELETE'][$route] = $handler;
  }
}