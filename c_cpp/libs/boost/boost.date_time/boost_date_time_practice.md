# boost.date_time practice

- [boost.date_time practice](#boostdate_time-practice)
  - [TimeStamp](#timestamp)


## TimeStamp

    #include <boost/date_time.hpp>

    std::string GetTimeStmpString()
    {
        std::ostringstream date_osstr;
        const static std::locale currlocale = std::locale(date_osstr.getloc(), new boost::posix_time::time_facet("%Y%m%d%H%M%S%F"));
        date_osstr.imbue(currlocale);
        const boost::posix_time::ptime& now = boost::posix_time::second_clock::local_time();
        date_osstr << now;
        return date_osstr.str();
    }
