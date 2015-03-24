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
    measurement_number=$3
    regeneration_plot_name=$4
    species=$5
    regeneration_count=$6
    regeneration_comment=$7
    company=$1
}

# awk rules based on user csv ruleset
NR == 1 && action == "validate" { headers="company|company_plot_number|measurement_number|regeneration_plot_name|species|regeneration_count|regeneration_comment"; if (!are_headers_valid(headers)) { gsub(/\|/, FS, headers); print RS "INVALID HEADERS IN " CSVFILENAME RS "WAS: " RS $0 RS "EXPECTED:" RS headers RS; exit 0; } }
NR == 1 && action == "validate:summary" { headers="company|company_plot_number|measurement_number|regeneration_plot_name|species|regeneration_count|regeneration_comment"; if (!are_headers_valid(headers)) { violations[CSVFILENAME FS "headers" FS  "names" FS "csv headers are invalid"]=1; exit 0; } }
action ~ /validate/ && NR > 1 { pkey=comnpany "-" company_plot_number "-" measurement_number "-" regeneration_plot_name "-" species; if(keys[pkey]) { if (dupkeys[pkey]) dupkeys[pkey]++; else dupkeys[pkey] = 1 } else { keys[pkey] = NR } }
action == "validate" && NR > 1 && company == "" { log_err("error"); print "Field company in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && company == "" { key=CSVFILENAME FS "company" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { log_err("error"); print "company in " CSVFILENAME " line " NR " should match the following pattern /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ and was " company " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { key=CSVFILENAME FS "company" FS  "pattern" FS "value should match: /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company_plot_number == "" { log_err("error"); print "Field company_plot_number in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && company_plot_number == "" { key=CSVFILENAME FS "company_plot_number" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company_plot_number != "" && length(company_plot_number) > 15 { log_err("error"); print "company_plot_number length in " CSVFILENAME " line " NR " should be less than 15 and was " length(company_plot_number) " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && company_plot_number != "" && length(company_plot_number) > 15 { key=CSVFILENAME FS "company_plot_number" FS  "maxLength" FS "max length is: 15"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && measurement_number && !is_numeric(measurement_number) { log_err("error"); print "Field measurement_number in " CSVFILENAME " line " NR " should be a numeric but was " measurement_number " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && measurement_number && !is_numeric(measurement_number) { key=CSVFILENAME FS "measurement_number" FS  "type" FS "max length is: 15"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && measurement_number == "" { log_err("error"); print "Field measurement_number in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && measurement_number == "" { key=CSVFILENAME FS "measurement_number" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && measurement_number != "" && length(measurement_number) > 2 { log_err("error"); print "measurement_number length in " CSVFILENAME " line " NR " should be less than 2 and was " length(measurement_number) " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && measurement_number != "" && length(measurement_number) > 2 { key=CSVFILENAME FS "measurement_number" FS  "maxLength" FS "max length is: 2"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && regeneration_plot_name == "" { log_err("error"); print "Field regeneration_plot_name in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && regeneration_plot_name == "" { key=CSVFILENAME FS "regeneration_plot_name" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && regeneration_plot_name != "" && regeneration_plot_name !~ /^(R1|R2|R3|R4|R5|R6|R7|R8|R9|R10)$/ { log_err("error"); print "regeneration_plot_name in " CSVFILENAME " line " NR " should match the following pattern /^(R1|R2|R3|R4|R5|R6|R7|R8|R9|R10)$/ and was " regeneration_plot_name " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && regeneration_plot_name != "" && regeneration_plot_name !~ /^(R1|R2|R3|R4|R5|R6|R7|R8|R9|R10)$/ { key=CSVFILENAME FS "regeneration_plot_name" FS  "pattern" FS "value should match: /^(R1|R2|R3|R4|R5|R6|R7|R8|R9|R10)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && species == "" { log_err("error"); print "Field species in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && species == "" { key=CSVFILENAME FS "species" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && species != "" && species !~ /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ { log_err("error"); print "species in " CSVFILENAME " line " NR " should match the following pattern /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ and was " species " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && species != "" && species !~ /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ { key=CSVFILENAME FS "species" FS  "pattern" FS "value should match: /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && regeneration_count && !is_numeric(regeneration_count) { log_err("warning"); print "Field regeneration_count in " CSVFILENAME " line " NR " should be a numeric but was " regeneration_count " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && regeneration_count && !is_numeric(regeneration_count) { key=CSVFILENAME FS "regeneration_count" FS  "type" FS "value should match: /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && regeneration_count != "" && regeneration_count < (species=="No"?0:1) { log_err("warning"); print "regeneration_count in " CSVFILENAME " line " NR " should be greater than (species=="No"?0:1) and was " regeneration_count " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && regeneration_count != "" && regeneration_count < (species=="No"?0:1) { key=CSVFILENAME FS "regeneration_count" FS  "minimum" FS "value should be greater than: (species=="No"?0:1)"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && regeneration_count != "" && regeneration_count > 9999 { log_err("warning"); print "regeneration_count in " CSVFILENAME " line " NR " should be less than 9999 and was " regeneration_count " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && regeneration_count != "" && regeneration_count > 9999 { key=CSVFILENAME FS "regeneration_count" FS  "maximum" FS "value should be less than: 9999"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 

# sanitize rules
action ~ /^(sanitize|insert)$/ && NR > 1 {
    if (species == "") $5 = "NA"
    if (regeneration_count == "") $6 = "-9999"
    if (regeneration_plot_name == "") $4 = "NA"
    if (measurement_number == "") $3 = "NA"
    if (company_plot_number == "") $2 = "NA"
    if (regeneration_comment == "") $7 = "NA"
    if (company == "") $1 = "NA"
}

# action handlers
action == "insert" && NR == 1 {
    print "COPY regeneration (" addfields FS "source_row_index" FS $0 ") FROM stdin;"
}
action == "insert" && NR > 1 {
    gsub(",", "\t");
    print addvals "\t" NR "\t" $0;
}
action == "table" && NR == 1 {
     print "CREATE TABLE IF NOT EXISTS regeneration (company text,company_plot_number text,measurement_number text,regeneration_plot_name text,species text,regeneration_count numeric,regeneration_comment text, CONSTRAINT regeneration_pkey PRIMARY KEY (comnpany,company_plot_number,measurement_number,regeneration_plot_name,species) , CONSTRAINT regeneration_plot_fkey FOREIGN KEY (company,company_plot_number) REFERENCES plot (company,company_plot_number) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION);"
}
action == "sanitize" { print }

# la fin
END {
    if (action == "validate:summary" && length(dupkeys) > 0) for (dup in dupkeys) { violation=CSVFILENAME FS "comnpany|company_plot_number|measurement_number|regeneration_plot_name|species" FS  "duplicate" FS dup " violates pkey"; violations[violation] = dupkeys[dup]}
    if (action == "validate:summary") { if (length(violations) > 0) for (violation in violations) { print violation FS violations[violation]; } }
    if (action == "validate" && options["summary"] == "true") { print RS "violation summary: " RS "   counts:   " RS "      total: " err_count; print_cats(cats); }
}
