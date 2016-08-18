BEGIN {
    FS="\t"
    print "{"
    print "  \"metadata\": {"
    print "    \"title\": \"ISO-639 language codes\","
    print "    \"source\": \"http://www.sil.org/iso639-3/\","
    printf "    \"created\": \"%s\"\n", strftime("%Y-%m-%d", systime())
    print "  },"
    print "  \"codes\": ["
}
{
   if (NR > 1) {
        printf "    { "
        printf "\"code\": \"%s\"", $1
        printf ", \"name\": \"%s\"", $7
        if ($2 != "") printf ", \"part2b\": \"%s\"", $2
        if ($3 != "") printf ", \"part2t\": \"%s\"", $3
        if ($4 != "") printf ", \"part1\": \"%s\"", $4
        if ($5 != "") printf ", \"scope\": \"%s\"", $5
        if ($6 != "") printf ", \"type\": \"%s\"", $6
        if ($8 != "") printf ", \"comment\": \"%s\"", $8
        printf " },\n"
    }
}
END {
    print "  ]"
    print "}"
}