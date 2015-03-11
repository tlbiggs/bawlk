#!/usr/bin/awk -F, -f

# generated by: awk-csvalid https://github.com/tesera/awk-csvalid

# awk-csvalid csv toolset generator: https://github.com/tesera/awk-csvalid
# usage:
#    validate:     awk -f action=validate validator.awk > violations.txt
#    create table: awk -v action=table -f validator.awk | psql afgo_dev
#    sanitize csv: awk -v action=sanitize -f validator.awk > sanitized.csv
#    insert sql:   awk -v action=insert -f validator.awk | psql afgo_dev

# awk is a simple unix text file parser: http://www.gnu.org/software/gawk/manual/gawk.html
# awk primer:
#    NR = number/index current record
#    RS = record seperator new line i.e. \n
#    FS = field seperator i.e. ,
#    /pattern/ { expression } = if pattern is truthy run expression

BEGIN {
    FS=","; OFS=","; err_count=0; cats["na"]=0;
    if(!action) action = "validate"
}

# builtin helper functions
function eql(x,y) {v=1; for (i in x) v=(v&&x[i]==y[i]); return v;}
function are_headers_valid(valid_headers) { v=0; split($0, h, ","); split(valid_headers, vh, "|"); return eql(h, vh); }
function is_unique(i, val) { if (vals[i,val]) { return 0; } else { vals[i,val] = 1; return 1; } }
function is_numeric(x){ return(x==x+0) }
function print_cats(categories) { for (category in categories) { if (categories[category]) print "      " category ": " categories[category]; } }
function log_err(cat) { cats[cat]++; err_count++; }


#get rid of the evil windows cr
{ sub("\r$", "") }


# make header index/map
NR > 1 {
    company_plot_number=$2
    tree_number=$3
    tree_label=$4
    tree_location_id=$5
    tree_origin=$6
    sector_or_quarter=$7
    species=$8
    distance=$9
    azimuth=$10
    trees_comment=$11
    company=$1
}

# awk rules based on user csv ruleset
NR == 1 { headers="company|company_plot_number|tree_number|tree_label|tree_location_id|tree_origin|sector_or_quarter|species|distance|azimuth|trees_comment"; if (!are_headers_valid(headers)) print "invalid headers in " FILENAME }
action == "validate" && NR > 1 && company == "" { log_err("warning"); print "Field company in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { log_err("warning"); print "company in " FILENAME " line " NR " should match the following pattern /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ and was " company " " RS $0 RS; } 
action == "validate" && NR > 1 && company_plot_number == "" { log_err("warning"); print "Field company_plot_number in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && tree_number && !is_numeric(tree_number) { log_err("warning"); print "Field tree_number in " FILENAME " line " NR " should be a numeric but was " tree_number " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_number == "" { log_err("warning"); print "Field tree_number in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && tree_number != "" && tree_number < 1 { log_err("warning"); print "tree_number in " FILENAME " line " NR " should be greater than 1 and was " tree_number " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_number != "" && tree_number > 999999 { log_err("warning"); print "tree_number in " FILENAME " line " NR " should be less than 999999 and was " tree_number " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_location_id && !is_numeric(tree_location_id) { log_err("warning"); print "Field tree_location_id in " FILENAME " line " NR " should be a numeric but was " tree_location_id " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_location_id == "" { log_err("warning"); print "Field tree_location_id in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && tree_location_id != "" && tree_location_id !~ /^(0|1|2|3)$/ { log_err("warning"); print "tree_location_id in " FILENAME " line " NR " should match the following pattern /^(0|1|2|3)$/ and was " tree_location_id " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_origin == "" { log_err("warning"); print "Field tree_origin in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && tree_origin != "" && tree_origin !~ /^(0|1|2|3|4|5|6|7|8|9|10)$/ { log_err("warning"); print "tree_origin in " FILENAME " line " NR " should match the following pattern /^(0|1|2|3|4|5|6|7|8|9|10)$/ and was " tree_origin " " RS $0 RS; } 
action == "validate" && NR > 1 && species != "" && species !~ /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ { log_err("warning"); print "species in " FILENAME " line " NR " should match the following pattern /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ and was " species " " RS $0 RS; } 
action == "validate" && NR > 1 && distance && !is_numeric(distance) { log_err("warning"); print "Field distance in " FILENAME " line " NR " should be a numeric but was " distance " " RS $0 RS; } 
action == "validate" && NR > 1 && azimuth && !is_numeric(azimuth) { log_err("warning"); print "Field azimuth in " FILENAME " line " NR " should be a numeric but was " azimuth " " RS $0 RS; } 

# sanitize rules
action ~ /^(sanitize|insert)$/ && NR > 1 {
    if (species == "") $8 = "NA"
    if (distance == "") $9 = "NA"
    if (tree_location_id == "") $5 = "NA"
    if (azimuth == "") $10 = "NA"
    if (tree_origin == "") $6 = "NA"
    if (tree_number == "") $3 = "-9999"
    if (trees_comment == "") $11 = "NA"
    if (company_plot_number == "") $2 = "NA"
    if (sector_or_quarter == "") $7 = "NA"
    if (company == "") $1 = "NA"
    if (tree_label == "") $4 = "NA"
}

# action handlers
action == "insert" && NR == 1 {
    print "SET client_encoding = 'UTF8';"
    gsub("Range", "rangeno");
    print "COPY  (" $0 ") FROM stdin;"
}
action == "insert" && NR > 1 {
    gsub(",", "	");
    print;
}
action == "table" && NR == 1 {
     print "CREATE TABLE IF NOT EXISTS  (company_plot_number text,tree_number numeric,tree_label text,tree_location_id text,tree_origin text,sector_or_quarter text,species text,distance text,azimuth text,trees_comment text,company text);"
}
action == "sanitize" { print }

# la fin
END {
    if (action == "insert") print "\\."
    if (action == "validate" && options["summary"] == "true") { print RS "violation summary: " RS "   counts:   " RS "      total: " err_count; print_cats(cats); }
}