require_once(__DIR__.'/../vendor/autoload.hack');
use namespace HH\Lib\C;

<<__EntryPoint>>
function main(): void {
  Facebook\AutoloadMap\initialize();
  
  $server = new Server();
  $server->get('/', ($req, $res) ==> {
    $res->status(200)->json(dict['Response' => $req->query['q']]);
  });

  $server->get('/test', ($req, $res) ==> {
    $res->status(200)->json(dict['Response' => 'Test endpoint']);
  });

  $server->post('/testing_post', ($req, $res) ==> {
    if (C\contains_key($req->body, 'lol')) {
      return $res->status(400)->json(dict[
        'Response' => dict[1 => 1]
      ]);
    }

    return $res->status(200)->json(dict[
      'Response' => $req->body['attr1']
    ]);
  });
  $server->process_request();
}