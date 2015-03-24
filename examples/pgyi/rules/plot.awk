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
    datum=$22
    company_plot_number=$2
    latitude=$23
    company_stand_number=$3
    longitude=$24
    establishment_year=$4
    natural_subregion=$25
    establishment_month=$5
    ecosite_guide=$26
    establishment_day=$6
    ecosite=$27
    fmu=$7
    ecosite_phase=$28
    fma=$8
    plot_comment=$29
    ats_township=$9
    ats_range=$10
    ats_meridian=$11
    ats_section=$12
    opening_number=$13
    sampling_unit_number=$14
    topographic_position=$15
    elevation=$16
    slope=$17
    aspect=$18
    x_coord=$19
    y_coord=$20
    utm_zone=$21
    company=$1
}

# awk rules based on user csv ruleset
NR == 1 && action == "validate" { headers="company|company_plot_number|company_stand_number|establishment_year|establishment_month|establishment_day|fmu|fma|ats_township|ats_range|ats_meridian|ats_section|opening_number|sampling_unit_number|topographic_position|elevation|slope|aspect|x_coord|y_coord|utm_zone|datum|latitude|longitude|natural_subregion|ecosite_guide|ecosite|ecosite_phase|plot_comment"; if (!are_headers_valid(headers)) { gsub(/\|/, FS, headers); print RS "INVALID HEADERS IN " CSVFILENAME RS "WAS: " RS $0 RS "EXPECTED:" RS headers RS; exit 0; } }
NR == 1 && action == "validate:summary" { headers="company|company_plot_number|company_stand_number|establishment_year|establishment_month|establishment_day|fmu|fma|ats_township|ats_range|ats_meridian|ats_section|opening_number|sampling_unit_number|topographic_position|elevation|slope|aspect|x_coord|y_coord|utm_zone|datum|latitude|longitude|natural_subregion|ecosite_guide|ecosite|ecosite_phase|plot_comment"; if (!are_headers_valid(headers)) { violations[CSVFILENAME FS "headers" FS  "names" FS "csv headers are invalid"]=1; exit 0; } }
action ~ /validate/ && NR > 1 { pkey=company "-" company_plot_number; if(keys[pkey]) { if (dupkeys[pkey]) dupkeys[pkey]++; else dupkeys[pkey] = 1 } else { keys[pkey] = NR } }
action == "validate" && NR > 1 && company == "" { log_err("error"); print "Field company in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && company == "" { key=CSVFILENAME FS "company" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { log_err("error"); print "company in " CSVFILENAME " line " NR " should match the following pattern /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ and was " company " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { key=CSVFILENAME FS "company" FS  "pattern" FS "value should match: /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company_plot_number == "" { log_err("error"); print "Field company_plot_number in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && company_plot_number == "" { key=CSVFILENAME FS "company_plot_number" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && !is_unique(company_plot_number) { log_err("error"); print "Field company_plot_number in " CSVFILENAME " line " NR " is a duplicate and should be unique" RS $0 RS; } 
action == "validate:summary" && NR > 1 && !is_unique(company_plot_number) { key=CSVFILENAME FS "company_plot_number" FS  "unique" FS "value should be unique but had duplicates"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company_plot_number != "" && length(company_plot_number) > 15 { log_err("error"); print "company_plot_number length in " CSVFILENAME " line " NR " should be less than 15 and was " length(company_plot_number) " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && company_plot_number != "" && length(company_plot_number) > 15 { key=CSVFILENAME FS "company_plot_number" FS  "maxLength" FS "max length is: 15"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company_stand_number != "" && length(company_stand_number) > 15 { log_err("error"); print "company_stand_number length in " CSVFILENAME " line " NR " should be less than 15 and was " length(company_stand_number) " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && company_stand_number != "" && length(company_stand_number) > 15 { key=CSVFILENAME FS "company_stand_number" FS  "maxLength" FS "max length is: 15"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && establishment_year && !is_numeric(establishment_year) { log_err("error"); print "Field establishment_year in " CSVFILENAME " line " NR " should be a numeric but was " establishment_year " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && establishment_year && !is_numeric(establishment_year) { key=CSVFILENAME FS "establishment_year" FS  "type" FS "max length is: 15"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && establishment_year == "" { log_err("error"); print "Field establishment_year in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && establishment_year == "" { key=CSVFILENAME FS "establishment_year" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && establishment_year != "" && establishment_year < 1900 { log_err("error"); print "establishment_year in " CSVFILENAME " line " NR " should be greater than 1900 and was " establishment_year " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && establishment_year != "" && establishment_year < 1900 { key=CSVFILENAME FS "establishment_year" FS  "minimum" FS "value should be greater than: 1900"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && establishment_year != "" && establishment_year > 2050 { log_err("error"); print "establishment_year in " CSVFILENAME " line " NR " should be less than 2050 and was " establishment_year " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && establishment_year != "" && establishment_year > 2050 { key=CSVFILENAME FS "establishment_year" FS  "maximum" FS "value should be less than: 2050"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && establishment_month && !is_numeric(establishment_month) { log_err("error"); print "Field establishment_month in " CSVFILENAME " line " NR " should be a numeric but was " establishment_month " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && establishment_month && !is_numeric(establishment_month) { key=CSVFILENAME FS "establishment_month" FS  "type" FS "value should be less than: 2050"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && establishment_month != "" && establishment_month < 1 { log_err("error"); print "establishment_month in " CSVFILENAME " line " NR " should be greater than 1 and was " establishment_month " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && establishment_month != "" && establishment_month < 1 { key=CSVFILENAME FS "establishment_month" FS  "minimum" FS "value should be greater than: 1"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && establishment_month != "" && establishment_month > 12 { log_err("error"); print "establishment_month in " CSVFILENAME " line " NR " should be less than 12 and was " establishment_month " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && establishment_month != "" && establishment_month > 12 { key=CSVFILENAME FS "establishment_month" FS  "maximum" FS "value should be less than: 12"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && establishment_day && !is_numeric(establishment_day) { log_err("error"); print "Field establishment_day in " CSVFILENAME " line " NR " should be a numeric but was " establishment_day " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && establishment_day && !is_numeric(establishment_day) { key=CSVFILENAME FS "establishment_day" FS  "type" FS "value should be less than: 12"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && establishment_day != "" && establishment_day < 1 { log_err("error"); print "establishment_day in " CSVFILENAME " line " NR " should be greater than 1 and was " establishment_day " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && establishment_day != "" && establishment_day < 1 { key=CSVFILENAME FS "establishment_day" FS  "minimum" FS "value should be greater than: 1"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && establishment_day != "" && establishment_day > 31 { log_err("error"); print "establishment_day in " CSVFILENAME " line " NR " should be less than 31 and was " establishment_day " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && establishment_day != "" && establishment_day > 31 { key=CSVFILENAME FS "establishment_day" FS  "maximum" FS "value should be less than: 31"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && fmu != "" && fmu !~ /^(A10|A11|A12|A13|A14|A4|A5|A6|A7|A8|A9|B10|B11|B9|BO1|BO2|C4|C5|CO1|CO2|E1|E10|E11|E2|E3|E4|E5|E6|E7|E8|E9|EO1|F1|F10|F11|F14|F20|F21|F23|F24|F25|FO1|G1|G10|G11|G12|G13|G14|G16|G2|G3|G4|G5|G6|G7|G8|G9|GO1|GO2|GO3|GO4|H1|L1|L11|L2|L3|L8|L9|LO1|M1|M10|M3|M4|M7|M9|NA|P1|P10|P11|P13|P3|P4|P5|P6|P7|P8|P9|PO1|PO2|PO3|R1|R10|R11|R13|R2|R2U|R3|R4|R4Y|RO1|S10|S11|S14|S15|S16|S17|S18|S19|S20|S21|S22|S7|S9|SO1|SO2|W1|W10|W11|W13|W14|W15|W2|W3|W4|W5|W6|W8|WO1|WO2|WO3|E14)$/ { log_err("error"); print "fmu in " CSVFILENAME " line " NR " should match the following pattern /^(A10|A11|A12|A13|A14|A4|A5|A6|A7|A8|A9|B10|B11|B9|BO1|BO2|C4|C5|CO1|CO2|E1|E10|E11|E2|E3|E4|E5|E6|E7|E8|E9|EO1|F1|F10|F11|F14|F20|F21|F23|F24|F25|FO1|G1|G10|G11|G12|G13|G14|G16|G2|G3|G4|G5|G6|G7|G8|G9|GO1|GO2|GO3|GO4|H1|L1|L11|L2|L3|L8|L9|LO1|M1|M10|M3|M4|M7|M9|NA|P1|P10|P11|P13|P3|P4|P5|P6|P7|P8|P9|PO1|PO2|PO3|R1|R10|R11|R13|R2|R2U|R3|R4|R4Y|RO1|S10|S11|S14|S15|S16|S17|S18|S19|S20|S21|S22|S7|S9|SO1|SO2|W1|W10|W11|W13|W14|W15|W2|W3|W4|W5|W6|W8|WO1|WO2|WO3|E14)$/ and was " fmu " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && fmu != "" && fmu !~ /^(A10|A11|A12|A13|A14|A4|A5|A6|A7|A8|A9|B10|B11|B9|BO1|BO2|C4|C5|CO1|CO2|E1|E10|E11|E2|E3|E4|E5|E6|E7|E8|E9|EO1|F1|F10|F11|F14|F20|F21|F23|F24|F25|FO1|G1|G10|G11|G12|G13|G14|G16|G2|G3|G4|G5|G6|G7|G8|G9|GO1|GO2|GO3|GO4|H1|L1|L11|L2|L3|L8|L9|LO1|M1|M10|M3|M4|M7|M9|NA|P1|P10|P11|P13|P3|P4|P5|P6|P7|P8|P9|PO1|PO2|PO3|R1|R10|R11|R13|R2|R2U|R3|R4|R4Y|RO1|S10|S11|S14|S15|S16|S17|S18|S19|S20|S21|S22|S7|S9|SO1|SO2|W1|W10|W11|W13|W14|W15|W2|W3|W4|W5|W6|W8|WO1|WO2|WO3|E14)$/ { key=CSVFILENAME FS "fmu" FS  "pattern" FS "value should match: /^(A10|A11|A12|A13|A14|A4|A5|A6|A7|A8|A9|B10|B11|B9|BO1|BO2|C4|C5|CO1|CO2|E1|E10|E11|E2|E3|E4|E5|E6|E7|E8|E9|EO1|F1|F10|F11|F14|F20|F21|F23|F24|F25|FO1|G1|G10|G11|G12|G13|G14|G16|G2|G3|G4|G5|G6|G7|G8|G9|GO1|GO2|GO3|GO4|H1|L1|L11|L2|L3|L8|L9|LO1|M1|M10|M3|M4|M7|M9|NA|P1|P10|P11|P13|P3|P4|P5|P6|P7|P8|P9|PO1|PO2|PO3|R1|R10|R11|R13|R2|R2U|R3|R4|R4Y|RO1|S10|S11|S14|S15|S16|S17|S18|S19|S20|S21|S22|S7|S9|SO1|SO2|W1|W10|W11|W13|W14|W15|W2|W3|W4|W5|W6|W8|WO1|WO2|WO3|E14)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && fma != "" && length(fma) > 30 { log_err("error"); print "fma length in " CSVFILENAME " line " NR " should be less than 30 and was " length(fma) " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && fma != "" && length(fma) > 30 { key=CSVFILENAME FS "fma" FS  "maxLength" FS "max length is: 30"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_township && !is_numeric(ats_township) { log_err("warning"); print "Field ats_township in " CSVFILENAME " line " NR " should be a numeric but was " ats_township " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_township && !is_numeric(ats_township) { key=CSVFILENAME FS "ats_township" FS  "type" FS "max length is: 30"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_township == "" { log_err("warning"); print "Field ats_township in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_township == "" { key=CSVFILENAME FS "ats_township" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_township != "" && ats_township < 1 { log_err("warning"); print "ats_township in " CSVFILENAME " line " NR " should be greater than 1 and was " ats_township " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_township != "" && ats_township < 1 { key=CSVFILENAME FS "ats_township" FS  "minimum" FS "value should be greater than: 1"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_township != "" && ats_township > 126 { log_err("warning"); print "ats_township in " CSVFILENAME " line " NR " should be less than 126 and was " ats_township " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_township != "" && ats_township > 126 { key=CSVFILENAME FS "ats_township" FS  "maximum" FS "value should be less than: 126"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_range && !is_numeric(ats_range) { log_err("warning"); print "Field ats_range in " CSVFILENAME " line " NR " should be a numeric but was " ats_range " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_range && !is_numeric(ats_range) { key=CSVFILENAME FS "ats_range" FS  "type" FS "value should be less than: 126"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_range == "" { log_err("warning"); print "Field ats_range in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_range == "" { key=CSVFILENAME FS "ats_range" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_range != "" && ats_range < 1 { log_err("warning"); print "ats_range in " CSVFILENAME " line " NR " should be greater than 1 and was " ats_range " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_range != "" && ats_range < 1 { key=CSVFILENAME FS "ats_range" FS  "minimum" FS "value should be greater than: 1"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_range != "" && ats_range > 26 { log_err("warning"); print "ats_range in " CSVFILENAME " line " NR " should be less than 26 and was " ats_range " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_range != "" && ats_range > 26 { key=CSVFILENAME FS "ats_range" FS  "maximum" FS "value should be less than: 26"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_meridian && !is_numeric(ats_meridian) { log_err("warning"); print "Field ats_meridian in " CSVFILENAME " line " NR " should be a numeric but was " ats_meridian " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_meridian && !is_numeric(ats_meridian) { key=CSVFILENAME FS "ats_meridian" FS  "type" FS "value should be less than: 26"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_meridian == "" { log_err("warning"); print "Field ats_meridian in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_meridian == "" { key=CSVFILENAME FS "ats_meridian" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_meridian != "" && ats_meridian < 4 { log_err("warning"); print "ats_meridian in " CSVFILENAME " line " NR " should be greater than 4 and was " ats_meridian " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_meridian != "" && ats_meridian < 4 { key=CSVFILENAME FS "ats_meridian" FS  "minimum" FS "value should be greater than: 4"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_meridian != "" && ats_meridian > 6 { log_err("warning"); print "ats_meridian in " CSVFILENAME " line " NR " should be less than 6 and was " ats_meridian " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_meridian != "" && ats_meridian > 6 { key=CSVFILENAME FS "ats_meridian" FS  "maximum" FS "value should be less than: 6"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_section && !is_numeric(ats_section) { log_err("warning"); print "Field ats_section in " CSVFILENAME " line " NR " should be a numeric but was " ats_section " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_section && !is_numeric(ats_section) { key=CSVFILENAME FS "ats_section" FS  "type" FS "value should be less than: 6"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_section == "" { log_err("warning"); print "Field ats_section in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_section == "" { key=CSVFILENAME FS "ats_section" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_section != "" && ats_section < 1 { log_err("warning"); print "ats_section in " CSVFILENAME " line " NR " should be greater than 1 and was " ats_section " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_section != "" && ats_section < 1 { key=CSVFILENAME FS "ats_section" FS  "minimum" FS "value should be greater than: 1"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ats_section != "" && ats_section > 36 { log_err("warning"); print "ats_section in " CSVFILENAME " line " NR " should be less than 36 and was " ats_section " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ats_section != "" && ats_section > 36 { key=CSVFILENAME FS "ats_section" FS  "maximum" FS "value should be less than: 36"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && opening_number != "" && length(opening_number) > 11 { log_err("undefined"); print "opening_number length in " CSVFILENAME " line " NR " should be less than 11 and was " length(opening_number) " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && opening_number != "" && length(opening_number) > 11 { key=CSVFILENAME FS "opening_number" FS  "maxLength" FS "max length is: 11"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sampling_unit_number != "" && length(sampling_unit_number) > 15 { log_err("undefined"); print "sampling_unit_number length in " CSVFILENAME " line " NR " should be less than 15 and was " length(sampling_unit_number) " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sampling_unit_number != "" && length(sampling_unit_number) > 15 { key=CSVFILENAME FS "sampling_unit_number" FS  "maxLength" FS "max length is: 15"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && topographic_position && !is_numeric(topographic_position) { log_err("warning"); print "Field topographic_position in " CSVFILENAME " line " NR " should be a numeric but was " topographic_position " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && topographic_position && !is_numeric(topographic_position) { key=CSVFILENAME FS "topographic_position" FS  "type" FS "max length is: 15"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && topographic_position != "" && topographic_position !~ /^(1|2|3|4|5|6|7)$/ { log_err("warning"); print "topographic_position in " CSVFILENAME " line " NR " should match the following pattern /^(1|2|3|4|5|6|7)$/ and was " topographic_position " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && topographic_position != "" && topographic_position !~ /^(1|2|3|4|5|6|7)$/ { key=CSVFILENAME FS "topographic_position" FS  "pattern" FS "value should match: /^(1|2|3|4|5|6|7)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && elevation && !is_numeric(elevation) { log_err("warning"); print "Field elevation in " CSVFILENAME " line " NR " should be a numeric but was " elevation " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && elevation && !is_numeric(elevation) { key=CSVFILENAME FS "elevation" FS  "type" FS "value should match: /^(1|2|3|4|5|6|7)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && elevation != "" && elevation < 0 { log_err("warning"); print "elevation in " CSVFILENAME " line " NR " should be greater than 0 and was " elevation " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && elevation != "" && elevation < 0 { key=CSVFILENAME FS "elevation" FS  "minimum" FS "value should be greater than: 0"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && elevation != "" && elevation > 3747 { log_err("warning"); print "elevation in " CSVFILENAME " line " NR " should be less than 3747 and was " elevation " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && elevation != "" && elevation > 3747 { key=CSVFILENAME FS "elevation" FS  "maximum" FS "value should be less than: 3747"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && slope && !is_numeric(slope) { log_err("warning"); print "Field slope in " CSVFILENAME " line " NR " should be a numeric but was " slope " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && slope && !is_numeric(slope) { key=CSVFILENAME FS "slope" FS  "type" FS "value should be less than: 3747"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && slope != "" && slope < 0 { log_err("warning"); print "slope in " CSVFILENAME " line " NR " should be greater than 0 and was " slope " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && slope != "" && slope < 0 { key=CSVFILENAME FS "slope" FS  "minimum" FS "value should be greater than: 0"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && slope != "" && slope > 200 { log_err("warning"); print "slope in " CSVFILENAME " line " NR " should be less than 200 and was " slope " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && slope != "" && slope > 200 { key=CSVFILENAME FS "slope" FS  "maximum" FS "value should be less than: 200"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && aspect != "" && aspect !~ /^(N|E|S|W|NE|SE|SW|NW|NA)$/ { log_err("warning"); print "aspect in " CSVFILENAME " line " NR " should match the following pattern /^(N|E|S|W|NE|SE|SW|NW|NA)$/ and was " aspect " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && aspect != "" && aspect !~ /^(N|E|S|W|NE|SE|SW|NW|NA)$/ { key=CSVFILENAME FS "aspect" FS  "pattern" FS "value should match: /^(N|E|S|W|NE|SE|SW|NW|NA)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && x_coord && !is_numeric(x_coord) { log_err("warning"); print "Field x_coord in " CSVFILENAME " line " NR " should be a numeric but was " x_coord " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && x_coord && !is_numeric(x_coord) { key=CSVFILENAME FS "x_coord" FS  "type" FS "value should match: /^(N|E|S|W|NE|SE|SW|NW|NA)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && x_coord != "" && x_coord < -1030400 { log_err("warning"); print "x_coord in " CSVFILENAME " line " NR " should be greater than -1030400 and was " x_coord " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && x_coord != "" && x_coord < -1030400 { key=CSVFILENAME FS "x_coord" FS  "minimum" FS "value should be greater than: -1030400"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && x_coord != "" && x_coord > -111700 { log_err("warning"); print "x_coord in " CSVFILENAME " line " NR " should be less than -111700 and was " x_coord " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && x_coord != "" && x_coord > -111700 { key=CSVFILENAME FS "x_coord" FS  "maximum" FS "value should be less than: -111700"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && y_coord && !is_numeric(y_coord) { log_err("warning"); print "Field y_coord in " CSVFILENAME " line " NR " should be a numeric but was " y_coord " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && y_coord && !is_numeric(y_coord) { key=CSVFILENAME FS "y_coord" FS  "type" FS "value should be less than: -111700"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && y_coord != "" && y_coord < 5643600 { log_err("warning"); print "y_coord in " CSVFILENAME " line " NR " should be greater than 5643600 and was " y_coord " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && y_coord != "" && y_coord < 5643600 { key=CSVFILENAME FS "y_coord" FS  "minimum" FS "value should be greater than: 5643600"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && y_coord != "" && y_coord > 6702500 { log_err("warning"); print "y_coord in " CSVFILENAME " line " NR " should be less than 6702500 and was " y_coord " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && y_coord != "" && y_coord > 6702500 { key=CSVFILENAME FS "y_coord" FS  "maximum" FS "value should be less than: 6702500"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && utm_zone == "" { log_err("error"); print "Field utm_zone in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && utm_zone == "" { key=CSVFILENAME FS "utm_zone" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && utm_zone != "" && utm_zone !~ /^(UTM11|UTM12)$/ { log_err("error"); print "utm_zone in " CSVFILENAME " line " NR " should match the following pattern /^(UTM11|UTM12)$/ and was " utm_zone " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && utm_zone != "" && utm_zone !~ /^(UTM11|UTM12)$/ { key=CSVFILENAME FS "utm_zone" FS  "pattern" FS "value should match: /^(UTM11|UTM12)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && datum == "" { log_err("error"); print "Field datum in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && datum == "" { key=CSVFILENAME FS "datum" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && datum != "" && datum !~ /^(NAD27|NAD83)$/ { log_err("error"); print "datum in " CSVFILENAME " line " NR " should match the following pattern /^(NAD27|NAD83)$/ and was " datum " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && datum != "" && datum !~ /^(NAD27|NAD83)$/ { key=CSVFILENAME FS "datum" FS  "pattern" FS "value should match: /^(NAD27|NAD83)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && latitude && !is_numeric(latitude) { log_err("undefined"); print "Field latitude in " CSVFILENAME " line " NR " should be a numeric but was " latitude " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && latitude && !is_numeric(latitude) { key=CSVFILENAME FS "latitude" FS  "type" FS "value should match: /^(NAD27|NAD83)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && latitude != "" && latitude < 49 { log_err("undefined"); print "latitude in " CSVFILENAME " line " NR " should be greater than 49 and was " latitude " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && latitude != "" && latitude < 49 { key=CSVFILENAME FS "latitude" FS  "minimum" FS "value should be greater than: 49"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && latitude != "" && latitude > 60 { log_err("undefined"); print "latitude in " CSVFILENAME " line " NR " should be less than 60 and was " latitude " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && latitude != "" && latitude > 60 { key=CSVFILENAME FS "latitude" FS  "maximum" FS "value should be less than: 60"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && longitude && !is_numeric(longitude) { log_err("undefined"); print "Field longitude in " CSVFILENAME " line " NR " should be a numeric but was " longitude " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && longitude && !is_numeric(longitude) { key=CSVFILENAME FS "longitude" FS  "type" FS "value should be less than: 60"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && longitude != "" && longitude < -120 { log_err("undefined"); print "longitude in " CSVFILENAME " line " NR " should be greater than -120 and was " longitude " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && longitude != "" && longitude < -120 { key=CSVFILENAME FS "longitude" FS  "minimum" FS "value should be greater than: -120"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && longitude != "" && longitude > -110 { log_err("undefined"); print "longitude in " CSVFILENAME " line " NR " should be less than -110 and was " longitude " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && longitude != "" && longitude > -110 { key=CSVFILENAME FS "longitude" FS  "maximum" FS "value should be less than: -110"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && natural_subregion == "" { log_err("error"); print "Field natural_subregion in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && natural_subregion == "" { key=CSVFILENAME FS "natural_subregion" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && natural_subregion != "" && natural_subregion !~ /^(CM|DM|NM|BSA|PAD|LBH|UBH|AP|ALP|SA|MT|UF|LF|KU|FP|PRP|CP|DMG|FF|NF|MG)$/ { log_err("error"); print "natural_subregion in " CSVFILENAME " line " NR " should match the following pattern /^(CM|DM|NM|BSA|PAD|LBH|UBH|AP|ALP|SA|MT|UF|LF|KU|FP|PRP|CP|DMG|FF|NF|MG)$/ and was " natural_subregion " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && natural_subregion != "" && natural_subregion !~ /^(CM|DM|NM|BSA|PAD|LBH|UBH|AP|ALP|SA|MT|UF|LF|KU|FP|PRP|CP|DMG|FF|NF|MG)$/ { key=CSVFILENAME FS "natural_subregion" FS  "pattern" FS "value should match: /^(CM|DM|NM|BSA|PAD|LBH|UBH|AP|ALP|SA|MT|UF|LF|KU|FP|PRP|CP|DMG|FF|NF|MG)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ecosite_guide == "" { log_err("undefined"); print "Field ecosite_guide in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && ecosite_guide == "" { key=CSVFILENAME FS "ecosite_guide" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ecosite_guide != "" && ecosite_guide !~ /^(N|WC|SW)$/ { log_err("undefined"); print "ecosite_guide in " CSVFILENAME " line " NR " should match the following pattern /^(N|WC|SW)$/ and was " ecosite_guide " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ecosite_guide != "" && ecosite_guide !~ /^(N|WC|SW)$/ { key=CSVFILENAME FS "ecosite_guide" FS  "pattern" FS "value should match: /^(N|WC|SW)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ecosite == "" { log_err("undefined"); print "Field ecosite in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && ecosite == "" { key=CSVFILENAME FS "ecosite" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ecosite != "" && ecosite !~ /^(a|b|c|d|e|f|g|h|I|j|k|l|m|n)$/ { log_err("undefined"); print "ecosite in " CSVFILENAME " line " NR " should match the following pattern /^(a|b|c|d|e|f|g|h|I|j|k|l|m|n)$/ and was " ecosite " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ecosite != "" && ecosite !~ /^(a|b|c|d|e|f|g|h|I|j|k|l|m|n)$/ { key=CSVFILENAME FS "ecosite" FS  "pattern" FS "value should match: /^(a|b|c|d|e|f|g|h|I|j|k|l|m|n)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ecosite_phase == "" { log_err("warning"); print "Field ecosite_phase in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && ecosite_phase == "" { key=CSVFILENAME FS "ecosite_phase" FS  "required" FS "value is required but was empty"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && ecosite_phase != "" && ecosite_phase !~ /^(1|b1|b2|b3|b4|c1|d1|d2|d3|e1|e2|e3|f1|f2|f3|g1|h1|i1|i2|j1|j2|k1|k2|k3|l1|h2|j3|a2|a3|g2|h3|b5|c2|c3|c4|c5|d4|e4|f4|f5|f6|g3|i3|l2|l3|m1|m2|m3|n1)$/ { log_err("warning"); print "ecosite_phase in " CSVFILENAME " line " NR " should match the following pattern /^(1|b1|b2|b3|b4|c1|d1|d2|d3|e1|e2|e3|f1|f2|f3|g1|h1|i1|i2|j1|j2|k1|k2|k3|l1|h2|j3|a2|a3|g2|h3|b5|c2|c3|c4|c5|d4|e4|f4|f5|f6|g3|i3|l2|l3|m1|m2|m3|n1)$/ and was " ecosite_phase " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && ecosite_phase != "" && ecosite_phase !~ /^(1|b1|b2|b3|b4|c1|d1|d2|d3|e1|e2|e3|f1|f2|f3|g1|h1|i1|i2|j1|j2|k1|k2|k3|l1|h2|j3|a2|a3|g2|h3|b5|c2|c3|c4|c5|d4|e4|f4|f5|f6|g3|i3|l2|l3|m1|m2|m3|n1)$/ { key=CSVFILENAME FS "ecosite_phase" FS  "pattern" FS "value should match: /^(1|b1|b2|b3|b4|c1|d1|d2|d3|e1|e2|e3|f1|f2|f3|g1|h1|i1|i2|j1|j2|k1|k2|k3|l1|h2|j3|a2|a3|g2|h3|b5|c2|c3|c4|c5|d4|e4|f4|f5|f6|g3|i3|l2|l3|m1|m2|m3|n1)$/"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 

# sanitize rules
action ~ /^(sanitize|insert)$/ && NR > 1 {
    if (x_coord == "") $19 = "-9999"
    if (aspect == "") $18 = "NA"
    if (topographic_position == "") $15 = "NA"
    if (elevation == "") $16 = "-9999"
    if (ats_range == "") $10 = "-9999"
    if (ats_section == "") $12 = "-9999"
    if (latitude == "") $23 = "-9999"
    if (sampling_unit_number == "") $14 = "NA"
    if (ecosite_guide == "") $26 = "NA"
    if (ats_township == "") $9 = "-9999"
    if (ecosite == "") $27 = "NA"
    if (opening_number == "") $13 = "NA"
    if (utm_zone == "") $21 = "NA"
    if (fmu == "") $7 = "NA"
    if (ats_meridian == "") $11 = "-9999"
    if (natural_subregion == "") $25 = "NA"
    if (y_coord == "") $20 = "-9999"
    if (company_plot_number == "") $2 = "NA"
    if (establishment_day == "") $6 = "-9999"
    if (longitude == "") $24 = "-9999"
    if (slope == "") $17 = "-9999"
    if (datum == "") $22 = "NA"
    if (establishment_year == "") $4 = "-9999"
    if (ecosite_phase == "") $28 = "NA"
    if (establishment_month == "") $5 = "-9999"
    if (company_stand_number == "") $3 = "NA"
    if (company == "") $1 = "NA"
    if (fma == "") $8 = "NA"
    if (plot_comment == "") $29 = "NA"
}

# action handlers
action == "insert" && NR == 1 {
    print "COPY plot (" addfields FS "source_row_index" FS $0 ") FROM stdin;"
}
action == "insert" && NR > 1 {
    gsub(",", "\t");
    print addvals "\t" NR "\t" $0;
}
action == "table" && NR == 1 {
     print "CREATE TABLE IF NOT EXISTS plot (company text,company_plot_number text,company_stand_number text,establishment_year numeric,establishment_month numeric,establishment_day numeric,fmu text,fma text,ats_township numeric,ats_range numeric,ats_meridian numeric,ats_section numeric,opening_number text,sampling_unit_number text,topographic_position text,elevation numeric,slope numeric,aspect text,x_coord numeric,y_coord numeric,utm_zone text,datum text,latitude numeric,longitude numeric,natural_subregion text,ecosite_guide text,ecosite text,ecosite_phase text,plot_comment text, CONSTRAINT plot_pkey PRIMARY KEY (company,company_plot_number) );"
}
action == "sanitize" { print }

# la fin
END {
    if (action == "validate:summary" && length(dupkeys) > 0) for (dup in dupkeys) { violation=CSVFILENAME FS "company|company_plot_number" FS  "duplicate" FS dup " violates pkey"; violations[violation] = dupkeys[dup]}
    if (action == "validate:summary") { if (length(violations) > 0) for (violation in violations) { print violation FS violations[violation]; } }
    if (action == "validate" && options["summary"] == "true") { print RS "violation summary: " RS "   counts:   " RS "      total: " err_count; print_cats(cats); }
}
