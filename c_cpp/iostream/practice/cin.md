# cin

- [cin](#cin)

## Read from `cin` line by line

    #include <iostream>
    #include <vector>
    #include <string>

    int main()
    {
        std::vector<std::string> v;

        std::string s;
        while (std::getline(std::cin, s)) {
            if (s.empty()) {  // encounter empty line, break
                break;
            }
            v.emplace_back(s);
        }

        std::cout << "================" << std::endl;
        for (const auto& e : v) {
            std::cout << e << std::endl;
        }

        return 0;
    }

## Read a line from `cin` and split by space charactor

    #include <iostream>
    #include <vector>
    #include <string>
    #include <sstream>

    int main()
    {
        std::vector<std::string> v;

        std::string s;
        std::getline(std::cin, s);

        std::stringstream ss(s);
        while (ss >> s) {
            v.emplace_back(s);
        }

        std::cout << "================" << std::endl;
        for (const auto& e : v) {
            std::cout << e << std::endl;
        }

        return 0;
    }

## Read a line from `cin` and split by comma charactor

    #include <iostream>
    #include <vector>
    #include <string>
    #include <sstream>

    int main()
    {
        std::vector<std::string> v;

        std::string s;
        std::getline(std::cin, s);

        std::stringstream ss(s);
        char delimiter = ',';
        while (std::getline(ss, s, delimiter)) {
            v.emplace_back(s);
        }

        std::cout << "================" << std::endl;
        for (const auto& e : v) {
            std::cout << e << std::endl;
        }

        return 0;
    }
