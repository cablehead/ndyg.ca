{|req|
  match $req {
    {method: "GET", path: "/"} => {
      open data/plantings.yaml | to json | minijinja-cli -f json ./html/index.html -
    }

    {method: "GET"} if ($req.path | str starts-with "/css/") => {
      .static "." $req.path
    }

    {method: "GET"} if ($req.path | str starts-with "/static/") => {
      .static "." $req.path
    }

    _ => {
      .response { status: 404 }
      $"Not Found: ($req.method) ($req.path)"
    }
  }
}
