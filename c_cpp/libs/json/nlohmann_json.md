# nlohmann json

- [nlohmann json](#nlohmann-json)
  - [GDB Pretty Printing](#gdb-pretty-printing)
  - [How Json Deal with Inf and Nan](#how-json-deal-with-inf-and-nan)

## [GDB Pretty Printing](https://github.com/nlohmann/json/issues/1952)

/opt/nlohmann/nlohmann_gdb.py

    # Pretty printing support for nlohmann::basic_json objects.
    
    import gdb.printing
    
    class NlohmannJsonPrinter(object):
        "Print a json"
        
        def __init__(self, val):
            self.val = val
            
        def to_string(self):
            eval_string = "(*("+str(self.val.type)+"*)("+str(self.val.address)+")).dump(2, ' ', false, nlohmann::detail::error_handler_t::strict).c_str()"
            result = gdb.parse_and_eval(eval_string)
            
            return result.string()
            
        def display_hint(self):
            return 'JSON'
            
    def build_pretty_printer():
        pp = gdb.printing.RegexpCollectionPrettyPrinter(
            "nlohmann::basic_json")
        pp.add_printer('JSON', '^nlohmann::basic_json<.*>$', NlohmannJsonPrinter)
        return pp
     
    def register_json_printer():
        gdb.printing.register_pretty_printer(
            gdb.current_objfile(),
            build_pretty_printer())
    
~/.gdbinit

    python
    sys.path.append('/opt/nlohmann')

    from nlohmann_gdb import register_json_printer
    register_json_printer()

## How Json Deal with Inf and Nan

- [Number Handling](https://json.nlohmann.me/features/types/number_handling/)

- [RFC 8259 - The JavaScript Object Notation (JSON) Data Interchange Format](https://www.rfc-editor.org/rfc/rfc8259)

  > 6.  Numbers
