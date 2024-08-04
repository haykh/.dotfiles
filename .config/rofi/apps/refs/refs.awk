BEGIN {
	entry_type = ""
	entry_key = ""
	in_entry = 0
	print "["
}

{
	if ($0 ~ /^@/) {
		if (in_entry) {
			printf "\n%s", "  }"
			in_entry = 0
		}
		if ($0 ~ /^@Comment/) {
			next
		}
		if (NR > 1) {
			print ","
		}
		entry_type = gensub(/^@([^{]+)\{([^,]+),/, "\\1", "g", $0)
		entry_key = gensub(/^@([^{]+)\{([^,]+),/, "\\2", "g", $0)
		entry_type = gensub(/^\s+|\s+$|\n/, "", "g", entry_type)
		entry_key = gensub(/^\s+|\s+$|\n/, "", "g", entry_key)
		gsub(/{|}/, "", entry_key)
		printf "  {\n    \"%s\": \"%s\",\n    \"%s\": \"%s\"", "type", entry_type, "key", entry_key
		in_entry = 1
	} else if (in_entry) {
		gsub(/^[ \t]+|[ \t]+$/, "", $0)
		split($0, arr, "=")
		key = arr[1]
		value = arr[2]
		# remove leading and trailing whitespace
		gsub(/^[ \t\r\n]+/, "", key)
		gsub(/[ \t\r\n]+$/, "", key)
		# ignore some keys
		ignored_keys = "abstract note publisher address pagetotal pages volume number month ppn_gvk archiveprefix primaryclass adsnote eid langid urldate series annote"
		if (index(ignored_keys, key) > 0) {
			next
		}
		# replace special characters
		gsub(/^[ \t\r\n]+/, "", value)
		gsub(/[ \t\r\n]+$/, "", value)
		gsub(/,$/, "", value)
		gsub(/\\&/, "\\\\&", value)
		gsub(/{\\^\\i}/, "i", value)
		gsub(/\{\\"a\}/, "\303\244", value)
		gsub(/\{\\"o\}/, "\303\266", value)
		gsub(/\{\\"u\}/, "\303\274", value)
		gsub(/\{\\"A\}/, "\303\204", value)
		gsub(/\{\\"O\}/, "\303\226", value)
		gsub(/\{\\"U\}/, "\303\234", value)
		gsub(/\{\\"i\}/, "\303\257", value)
		gsub(/\{\\"\\i\}/, "\303\257", value)
		gsub(/\{\\"I\}/, "\303\217", value)
		gsub(/\{\\\x27a\}/, "\303\241", value)
		gsub(/\{\\\x27e\}/, "\303\251", value)
		gsub(/\{\\\x27i\}/, "\303\255", value)
		gsub(/\{\\\x27\\i\}/, "\303\255", value)
		gsub(/\{\\\^\\i\}/, "\303\255", value)
		gsub(/\{\\\x27o\}/, "\303\263", value)
		gsub(/\{\\\x27u\}/, "\303\272", value)
		gsub(/\{\\\x27n\}/, "\305\204", value)
		gsub(/\{\\v{z}\}/, "\305\272", value)
		gsub(/\{\\\x27A\}/, "\303\201", value)
		gsub(/\{\\\x27E\}/, "\303\211", value)
		gsub(/\{\\\x27I\}/, "\303\215", value)
		gsub(/\{\\\x27O\}/, "\303\223", value)
		gsub(/\{\\\x27U\}/, "\303\232", value)
		gsub(/\{\\\x27N\}/, "\305\203", value)
		gsub(/\{\\v{Z}\}/, "\305\271", value)
		gsub(/\{\\`a\}/, "\303\240", value)
		gsub(/\{\\`e\}/, "\303\250", value)
		gsub(/\{\\`i\}/, "\303\254", value)
		gsub(/\{\\`o\}/, "\303\262", value)
		gsub(/\{\\`u\}/, "\303\271", value)
		gsub(/\{\\`A\}/, "\303\200", value)
		gsub(/\{\\`E\}/, "\303\210", value)
		gsub(/\{\\`I\}/, "\303\214", value)
		gsub(/\{\\`O\}/, "\303\222", value)
		gsub(/\{\\`U\}/, "\303\231", value)
		gsub(/\{\\^a\}/, "\303\242", value)
		gsub(/\{\\^e\}/, "\303\252", value)
		gsub(/\{\\^i\}/, "\303\256", value)
		gsub(/\{\\^\\i\}/, "\303\256", value)
		gsub(/\{\\^o\}/, "\303\264", value)
		gsub(/\{\\^u\}/, "\303\273", value)
		gsub(/\{\\^A\}/, "\303\202", value)
		gsub(/\{\\^E\}/, "\303\212", value)
		gsub(/\{\\^I\}/, "\303\216", value)
		gsub(/\{\\^O\}/, "\303\224", value)
		gsub(/\{\\^U\}/, "\303\233", value)
		gsub(/\{\\~n\}/, "\303\261", value)
		gsub(/\{\\~N\}/, "\303\221", value)
		gsub(/\{\\~a\}/, "\303\243", value)
		gsub(/\{\\~o\}/, "\303\265", value)
		gsub(/\{\\~A\}/, "\303\203", value)
		gsub(/\{\\l\}/, "\305\202", value)
		gsub(/\{\\~u\}/, "\303\274", value)
		gsub(/\{\\.z\}/, "\305\274", value)
		gsub(/\{\\.Z\}/, "\305\273", value)
		gsub(/\{\\ss\}/, "\303\237", value)
		gsub(/\{\\c{c}\}/, "\303\247", value)
		gsub(/\{\\c{C}\}/, "\303\207", value)
		gsub(/\{\\c{e}\}/, "\304\231", value)
		gsub(/\{\\c{E}\}/, "\304\230", value)
		gsub(/{\\alpha}/, "\316\261", value)
		gsub(/{\\beta}/, "\316\262", value)
		gsub(/{\\gamma}/, "\316\263", value)
		gsub(/{\\delta}/, "\316\264", value)
		gsub(/{\\epsilon}/, "\316\265", value)
		gsub(/{\\zeta}/, "\316\266", value)
		gsub(/{\\eta}/, "\316\267", value)
		gsub(/{\\theta}/, "\316\270", value)
		gsub(/{\\iota}/, "\316\271", value)
		gsub(/{\\kappa}/, "\316\272", value)
		gsub(/{\\lambda}/, "\316\273", value)
		gsub(/{\\mu}/, "\316\274", value)
		gsub(/{\\nu}/, "\316\275", value)
		gsub(/{\\xi}/, "\316\276", value)
		gsub(/{\\pi}/, "\317\200", value)
		gsub(/{\\rho}/, "\317\201", value)
		gsub(/{\\sigma}/, "\317\203", value)
		gsub(/{\\tau}/, "\317\204", value)
		gsub(/{\\upsilon}/, "\317\205", value)
		gsub(/{\\phi}/, "\317\206", value)
		gsub(/{\\chi}/, "\317\207", value)
		gsub(/{\\psi}/, "\317\210", value)
		gsub(/{\\omega}/, "\317\211", value)
		gsub(/\\alpha/, "\316\261", value)
		gsub(/\\beta/, "\316\262", value)
		gsub(/\\gamma/, "\316\263", value)
		gsub(/\\delta/, "\316\264", value)
		gsub(/\\epsilon/, "\316\265", value)
		gsub(/\\zeta/, "\316\266", value)
		gsub(/\\eta/, "\316\267", value)
		gsub(/\\theta/, "\316\270", value)
		gsub(/\\iota/, "\316\271", value)
		gsub(/\\kappa/, "\316\272", value)
		gsub(/\\lambda/, "\316\273", value)
		gsub(/\\mu/, "\316\274", value)
		gsub(/\\nu/, "\316\275", value)
		gsub(/\\xi/, "\316\276", value)
		gsub(/\\pi/, "\317\200", value)
		gsub(/\\rho/, "\317\201", value)
		gsub(/\\sigma/, "\317\203", value)
		gsub(/\\tau/, "\317\204", value)
		gsub(/\\upsilon/, "\317\205", value)
		gsub(/\\phi/, "\317\206", value)
		gsub(/\\chi/, "\317\207", value)
		gsub(/\\psi/, "\317\210", value)
		gsub(/\\omega/, "\317\211", value)
		gsub(/\\ensuremath/, "", value)
		gsub(/\\mathrm/, "", value)
		gsub(/\\gtrsim/, "\342\211\263", value)
		gsub(/\\lesssim/, "\342\211\262", value)
		gsub(/\\simeq/, "\342\211\203", value)
		gsub(/\\sim/, "\342\210\274", value)
		# cleanup extra spaces
		if (key != "file" && key != "url") {
			gsub(/- +/, "-", value)
			gsub(/[[:space:]]+/, " ", value)
		}
		# cleanup possible latex commands
		gsub(/{|}|~/, "", value)
		# cleanup author field (remove "and", names, and add et al. if more than 3 authors)
		if (key == "author") {
			gsub(/, [^,]* and /, ", ", value)
			gsub(/, [^,]*$/, "", value)
			num_commas = gsub(/,/, "&", value)
			if (num_commas > 2) {
				match(value, /([^,]*,){3}/)
				third_comma_pos = RSTART + RLENGTH - 1
				value = substr(value, 1, third_comma_pos) " et al."
			}
		}
		if (key == "journal") {
			if (value == "Astrophysical Journal" || value == "The Astrophysical Journal") {
				value = "ApJ"
			} else if (value == "Astrophysical Journal Letters") {
				value = "ApJL"
			} else if (value == "Astrophysical Journal: Supplement" || value == "Astrophysical Journal Supplement") {
				value = "ApJS"
			} else if (value == "Astronomy and Astrophysics" || value == "Astronomy & Astrophysics") {
				value = "A&amp;A"
			} else if (value == "Monthly Notices of the Royal Astronomical Society") {
				value = "MNRAS"
			} else if (value == "Physical Review D") {
				value = "PRD"
			} else if (value == "Physical Review Letters") {
				value = "PRL"
			} else if (value == "Journal of Plasma Physics") {
				value = "JPP"
			}
		}
		# cleanup file name
		if (key == "file") {
			if (match(value, /:([^:]*):/, arr)) {
				value = arr[1]
			}
		}
		if (key != "" && value != "") {
			printf ",\n    \"%s\": \"%s\"", key, value
		}
	}
}

END {
	if (in_entry) {
		print "  }"
	}
	printf "\n]"
}

