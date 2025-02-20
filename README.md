Previously this site was rendered using
[Bash](https://x.com/badcop_/status/1785466291660431387) /
[http-sh](https://github.com/cablehead/http-sh)

It's now rendered using [Nushell](https://www.nushell.sh) /
[http-nu](https://github.com/cablehead/http-nu)

Requirements:

- [http-nu](https://github.com/cablehead/http-nu)
- [minijinja](https://github.com/mitsuhiko/minijinja)

```nushell
http-nu :5002 (open serve.nu)
```

Then visit: http://localhost:5002
