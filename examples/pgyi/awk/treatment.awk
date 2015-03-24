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
    summary_header="file_name,field_name,rule,message,violation_count"
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
    treatment_number=$3
    treatment_code=$4
    treatment_year=$5
    treatment_month=$6
    treatment_day=$7
    treatment_comment=$8
    company=$1
}

# awk rules based on user csv ruleset
NR == 1 && action == "validate" { headers="company|company_plot_number|treatment_number|treatment_code|treatment_year|treatment_month|treatment_day|treatment_comment"; if (!are_headers_valid(headers)) { gsub(/\|/, FS, headers); print RS "INVALID HEADERS IN " CSVFILENAME RS "WAS: " RS $0 RS "EXPECTED:" RS headers RS; exit 0; } }
NR == 1 && action == "validate:summary" { headers="company|company_plot_number|treatment_number|treatment_code|treatment_year|treatment_month|treatment_day|treatment_comment"; if (!are_headers_valid(headers)) { violations[CSVFILENAME FS "headers" FS  "names" FS "csv headers are invalid"]=1; exit 0; } }
action ~ /validate/ && NR > 1 { pkey=company "-" company_plot_number "-" treatment_number; if(keys[pkey]) { if (dupkeys[pkey]) dupkeys[pkey]++; else dupkeys[pkey] = 1 } else { keys[pkey] = NR } }
action == "validate" && NR > 1 && company == "" { log_err("error"); print "Field company in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && company == "" { key=CSVFILENAME FS "company" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { log_err("error"); print "company in " CSVFILENAME " line " NR " should match the following pattern /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ and was " company " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { key=CSVFILENAME FS "company" FS  "pattern" FS "value should match: /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company_plot_number == "" { log_err("error"); print "Field company_plot_number in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && company_plot_number == "" { key=CSVFILENAME FS "company_plot_number" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company_plot_number != "" && length(company_plot_number) > 15 { log_err("error"); print "company_plot_number length in " CSVFILENAME " line " NR " should be less than 15 and was " length(company_plot_number) " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && company_plot_number != "" && length(company_plot_number) > 15 { key=CSVFILENAME FS "company_plot_number" FS  "maxLength" FS "max length is: 15"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_number && !is_numeric(treatment_number) { log_err("error"); print "Field treatment_number in " CSVFILENAME " line " NR " should be a numeric but was " treatment_number " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_number && !is_numeric(treatment_number) { key=CSVFILENAME FS "treatment_number" FS  "type" FS "max length is: 15"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_number != "" && treatment_number < 1 { log_err("error"); print "treatment_number in " CSVFILENAME " line " NR " should be greater than 1 and was " treatment_number " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_number != "" && treatment_number < 1 { key=CSVFILENAME FS "treatment_number" FS  "minimum" FS "value should be greater than: 1"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_number != "" && treatment_number > 12 { log_err("error"); print "treatment_number in " CSVFILENAME " line " NR " should be less than 12 and was " treatment_number " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_number != "" && treatment_number > 12 { key=CSVFILENAME FS "treatment_number" FS  "maximum" FS "value should be less than: 12"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_code != "" && treatment_code !~ /^(NT|P|H|M|C|B|TH|TW|F|FI|PC|CT|S|UP|UA|D|NK)$/ { log_err("error"); print "treatment_code in " CSVFILENAME " line " NR " should match the following pattern /^(NT|P|H|M|C|B|TH|TW|F|FI|PC|CT|S|UP|UA|D|NK)$/ and was " treatment_code " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_code != "" && treatment_code !~ /^(NT|P|H|M|C|B|TH|TW|F|FI|PC|CT|S|UP|UA|D|NK)$/ { key=CSVFILENAME FS "treatment_code" FS  "pattern" FS "value should match: /^(NT|P|H|M|C|B|TH|TW|F|FI|PC|CT|S|UP|UA|D|NK)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_year && !is_numeric(treatment_year) { log_err("error"); print "Field treatment_year in " CSVFILENAME " line " NR " should be a numeric but was " treatment_year " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_year && !is_numeric(treatment_year) { key=CSVFILENAME FS "treatment_year" FS  "type" FS "value should match: /^(NT|P|H|M|C|B|TH|TW|F|FI|PC|CT|S|UP|UA|D|NK)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_code~/^(NT|NK)$/ && treatment_year == "" { log_err("error"); print "Field treatment_year in " CSVFILENAME " line " NR " is required if treatment_code~/^(NT|NK)$/" RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_code~/^(NT|NK)$/ && treatment_year == "" { key=CSVFILENAME FS "treatment_year" FS  "required" FS "value is required if treatment_code~/^(NT|NK)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_year != "" && treatment_year < 1900 { log_err("error"); print "treatment_year in " CSVFILENAME " line " NR " should be greater than 1900 and was " treatment_year " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_year != "" && treatment_year < 1900 { key=CSVFILENAME FS "treatment_year" FS  "minimum" FS "value should be greater than: 1900"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_year != "" && treatment_year > 2050 { log_err("error"); print "treatment_year in " CSVFILENAME " line " NR " should be less than 2050 and was " treatment_year " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_year != "" && treatment_year > 2050 { key=CSVFILENAME FS "treatment_year" FS  "maximum" FS "value should be less than: 2050"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_month && !is_numeric(treatment_month) { log_err("warning"); print "Field treatment_month in " CSVFILENAME " line " NR " should be a numeric but was " treatment_month " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_month && !is_numeric(treatment_month) { key=CSVFILENAME FS "treatment_month" FS  "type" FS "value should be less than: 2050"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_code~/^(NT|NK)$/ && treatment_month == "" { log_err("warning"); print "Field treatment_month in " CSVFILENAME " line " NR " is required if treatment_code~/^(NT|NK)$/" RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_code~/^(NT|NK)$/ && treatment_month == "" { key=CSVFILENAME FS "treatment_month" FS  "required" FS "value is required if treatment_code~/^(NT|NK)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_month != "" && treatment_month < 1 { log_err("warning"); print "treatment_month in " CSVFILENAME " line " NR " should be greater than 1 and was " treatment_month " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_month != "" && treatment_month < 1 { key=CSVFILENAME FS "treatment_month" FS  "minimum" FS "value should be greater than: 1"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_month != "" && treatment_month > 12 { log_err("warning"); print "treatment_month in " CSVFILENAME " line " NR " should be less than 12 and was " treatment_month " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_month != "" && treatment_month > 12 { key=CSVFILENAME FS "treatment_month" FS  "maximum" FS "value should be less than: 12"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_day && !is_numeric(treatment_day) { log_err("warning"); print "Field treatment_day in " CSVFILENAME " line " NR " should be a numeric but was " treatment_day " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_day && !is_numeric(treatment_day) { key=CSVFILENAME FS "treatment_day" FS  "type" FS "value should be less than: 12"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_day != "" && treatment_day < 1 { log_err("warning"); print "treatment_day in " CSVFILENAME " line " NR " should be greater than 1 and was " treatment_day " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_day != "" && treatment_day < 1 { key=CSVFILENAME FS "treatment_day" FS  "minimum" FS "value should be greater than: 1"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && treatment_day != "" && treatment_day > 31 { log_err("warning"); print "treatment_day in " CSVFILENAME " line " NR " should be less than 31 and was " treatment_day " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && treatment_day != "" && treatment_day > 31 { key=CSVFILENAME FS "treatment_day" FS  "maximum" FS "value should be less than: 31"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 

# sanitize rules
action ~ /^(sanitize|insert)$/ && NR > 1 {
    if (treatment_month == "") $6 = "-9999"
    if (treatment_code == "") $4 = "NA"
    if (treatment_year == "") $5 = "-9999"
    if (treatment_number == "") $3 = "-9999"
    if (treatment_comment == "") $8 = "NA"
    if (treatment_day == "") $7 = "-9999"
    if (company_plot_number == "") $2 = "NA"
    if (company == "") $1 = "NA"
}

# action handlers
action == "insert" && NR == 1 {
    print "COPY treatment (" addfields FS "source_row_index" FS $0 ") FROM stdin;"
}
action == "insert" && NR > 1 {
    gsub(",", "\t");
    print addvals "\t" NR "\t" $0;
}
action == "table" && NR == 1 {
     print "CREATE TABLE IF NOT EXISTS treatment (company text,company_plot_number text,treatment_number numeric,treatment_code text,treatment_year numeric,treatment_month numeric,treatment_day numeric,treatment_comment text, CONSTRAINT treatment_pkey PRIMARY KEY (company,company_plot_number,treatment_number) , CONSTRAINT treatment_plot_fkey FOREIGN KEY (company,company_plot_number) REFERENCES plot (company,company_plot_number) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION);"
}
action == "sanitize" { print }

# la fin
END {
    if (action == "validate:summary" && length(dupkeys) > 0) for (dup in dupkeys) { violation=CSVFILENAME FS "company|company_plot_number|treatment_number" FS  "duplicate" FS dup " violates pkey"; violations[violation] = dupkeys[dup]}
    if (action == "validate:summary") { if (length(violations) > 0) for (violation in violations) { print violation FS violations[violation]; } }
    if (action == "validate" && options["summary"] == "true") { print RS "violation summary: " RS "   counts:   " RS "      total: " err_count; print_cats(cats); }
}
