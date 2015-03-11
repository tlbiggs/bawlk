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
    number_regen_plots=$22
    company_plot_number=$2
    contractor=$23
    measurement_number=$3
    cruiser_1_name=$24
    measurement_year=$4
    cruiser_2_name=$25
    measurement_month=$5
    shrub_cover=$26
    measurement_day=$6
    herb_forb_cover=$27
    stand_origin=$7
    grass_cover=$28
    plot_type=$8
    moss_lichen_cover=$29
    stand_type=$9
    plot_status=$10
    tree_plot_area=$11
    tree_plot_shape=$12
    tree_tagging_limit=$13
    sapling_plot_area=$14
    sapling_plot_shape=$15
    sapling_tagging_limit_dbh=$16
    sapling_tagging_limit_height=$17
    regen_plot_area=$18
    regen_plot_shape=$19
    avi_field_call=$30
    plot_measurement_comment=$31
    regen_tagging_limit_conifer=$20
    regen_tagging_limit_decid=$21
    company=$1
}

# awk rules based on user csv ruleset
NR == 1 { headers="company|company_plot_number|measurement_number|measurement_year|measurement_month|measurement_day|stand_origin|plot_type|stand_type|plot_status|tree_plot_area|tree_plot_shape|tree_tagging_limit|sapling_plot_area|sapling_plot_shape|sapling_tagging_limit_dbh|sapling_tagging_limit_height|regen_plot_area|regen_plot_shape|regen_tagging_limit_conifer|regen_tagging_limit_decid|number_regen_plots|contractor|cruiser_1_name|cruiser_2_name|shrub_cover|herb_forb_cover|grass_cover|moss_lichen_cover|avi_field_call|plot_measurement_comment"; if (!are_headers_valid(headers)) print "invalid headers in " FILENAME }
action == "validate" && NR > 1 && company == "" { log_err("warning"); print "Field company in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { log_err("warning"); print "company in " FILENAME " line " NR " should match the following pattern /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ and was " company " " RS $0 RS; } 
action == "validate" && NR > 1 && company_plot_number == "" { log_err("warning"); print "Field company_plot_number in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && measurement_number && !is_numeric(measurement_number) { log_err("warning"); print "Field measurement_number in " FILENAME " line " NR " should be a numeric but was " measurement_number " " RS $0 RS; } 
action == "validate" && NR > 1 && measurement_year && !is_numeric(measurement_year) { log_err("warning"); print "Field measurement_year in " FILENAME " line " NR " should be a numeric but was " measurement_year " " RS $0 RS; } 
action == "validate" && NR > 1 && measurement_year != "" && measurement_year < 1900 { log_err("warning"); print "measurement_year in " FILENAME " line " NR " should be greater than 1900 and was " measurement_year " " RS $0 RS; } 
action == "validate" && NR > 1 && measurement_year != "" && measurement_year > 2050 { log_err("warning"); print "measurement_year in " FILENAME " line " NR " should be less than 2050 and was " measurement_year " " RS $0 RS; } 
action == "validate" && NR > 1 && measurement_month && !is_numeric(measurement_month) { log_err("warning"); print "Field measurement_month in " FILENAME " line " NR " should be a numeric but was " measurement_month " " RS $0 RS; } 
action == "validate" && NR > 1 && measurement_month != "" && measurement_month < 1 { log_err("warning"); print "measurement_month in " FILENAME " line " NR " should be greater than 1 and was " measurement_month " " RS $0 RS; } 
action == "validate" && NR > 1 && measurement_month != "" && measurement_month > 12 { log_err("warning"); print "measurement_month in " FILENAME " line " NR " should be less than 12 and was " measurement_month " " RS $0 RS; } 
action == "validate" && NR > 1 && measurement_day && !is_numeric(measurement_day) { log_err("warning"); print "Field measurement_day in " FILENAME " line " NR " should be a numeric but was " measurement_day " " RS $0 RS; } 
action == "validate" && NR > 1 && measurement_day != "" && measurement_day < 1 { log_err("warning"); print "measurement_day in " FILENAME " line " NR " should be greater than 1 and was " measurement_day " " RS $0 RS; } 
action == "validate" && NR > 1 && measurement_day != "" && measurement_day > 31 { log_err("warning"); print "measurement_day in " FILENAME " line " NR " should be less than 31 and was " measurement_day " " RS $0 RS; } 
action == "validate" && NR > 1 && stand_origin != "" && stand_origin !~ /^(C|L|F|P|R|N|S|A|B)$/ { log_err("warning"); print "stand_origin in " FILENAME " line " NR " should match the following pattern /^(C|L|F|P|R|N|S|A|B)$/ and was " stand_origin " " RS $0 RS; } 
action == "validate" && NR > 1 && plot_type && !is_numeric(plot_type) { log_err("warning"); print "Field plot_type in " FILENAME " line " NR " should be a numeric but was " plot_type " " RS $0 RS; } 
action == "validate" && NR > 1 && plot_type != "" && plot_type !~ /^(1|2|3|4)$/ { log_err("warning"); print "plot_type in " FILENAME " line " NR " should match the following pattern /^(1|2|3|4)$/ and was " plot_type " " RS $0 RS; } 
action == "validate" && NR > 1 && stand_type && !is_numeric(stand_type) { log_err("warning"); print "Field stand_type in " FILENAME " line " NR " should be a numeric but was " stand_type " " RS $0 RS; } 
action == "validate" && NR > 1 && stand_type != "" && stand_type !~ /^(1|2|3)$/ { log_err("warning"); print "stand_type in " FILENAME " line " NR " should match the following pattern /^(1|2|3)$/ and was " stand_type " " RS $0 RS; } 
action == "validate" && NR > 1 && plot_status && !is_numeric(plot_status) { log_err("warning"); print "Field plot_status in " FILENAME " line " NR " should be a numeric but was " plot_status " " RS $0 RS; } 
action == "validate" && NR > 1 && plot_status != "" && plot_status !~ /^(1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|)$/ { log_err("warning"); print "plot_status in " FILENAME " line " NR " should match the following pattern /^(1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|)$/ and was " plot_status " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_plot_area && !is_numeric(tree_plot_area) { log_err("warning"); print "Field tree_plot_area in " FILENAME " line " NR " should be a numeric but was " tree_plot_area " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_plot_area != "" && tree_plot_area < 400 { log_err("warning"); print "tree_plot_area in " FILENAME " line " NR " should be greater than 400 and was " tree_plot_area " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_plot_area != "" && tree_plot_area > 2500 { log_err("warning"); print "tree_plot_area in " FILENAME " line " NR " should be less than 2500 and was " tree_plot_area " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_plot_shape != "" && tree_plot_shape !~ /^(C|R|S)$/ { log_err("warning"); print "tree_plot_shape in " FILENAME " line " NR " should match the following pattern /^(C|R|S)$/ and was " tree_plot_shape " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_tagging_limit && !is_numeric(tree_tagging_limit) { log_err("warning"); print "Field tree_tagging_limit in " FILENAME " line " NR " should be a numeric but was " tree_tagging_limit " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_tagging_limit != "" && tree_tagging_limit < 0 { log_err("warning"); print "tree_tagging_limit in " FILENAME " line " NR " should be greater than 0 and was " tree_tagging_limit " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_tagging_limit != "" && tree_tagging_limit > 9.1 { log_err("warning"); print "tree_tagging_limit in " FILENAME " line " NR " should be less than 9.1 and was " tree_tagging_limit " " RS $0 RS; } 
action == "validate" && NR > 1 && sapling_plot_area && !is_numeric(sapling_plot_area) { log_err("warning"); print "Field sapling_plot_area in " FILENAME " line " NR " should be a numeric but was " sapling_plot_area " " RS $0 RS; } 
action == "validate" && NR > 1 && sapling_plot_area != "" && sapling_plot_area < 40 { log_err("warning"); print "sapling_plot_area in " FILENAME " line " NR " should be greater than 40 and was " sapling_plot_area " " RS $0 RS; } 
action == "validate" && NR > 1 && sapling_plot_area != "" && sapling_plot_area > 2500 { log_err("warning"); print "sapling_plot_area in " FILENAME " line " NR " should be less than 2500 and was " sapling_plot_area " " RS $0 RS; } 
action == "validate" && NR > 1 && sapling_plot_shape != "" && sapling_plot_shape !~ /^(C|R|S)$/ { log_err("warning"); print "sapling_plot_shape in " FILENAME " line " NR " should match the following pattern /^(C|R|S)$/ and was " sapling_plot_shape " " RS $0 RS; } 
action == "validate" && NR > 1 && sapling_tagging_limit_dbh && !is_numeric(sapling_tagging_limit_dbh) { log_err("warning"); print "Field sapling_tagging_limit_dbh in " FILENAME " line " NR " should be a numeric but was " sapling_tagging_limit_dbh " " RS $0 RS; } 
action == "validate" && NR > 1 && sapling_tagging_limit_dbh != "" && sapling_tagging_limit_dbh < 0.1 { log_err("warning"); print "sapling_tagging_limit_dbh in " FILENAME " line " NR " should be greater than 0.1 and was " sapling_tagging_limit_dbh " " RS $0 RS; } 
action == "validate" && NR > 1 && sapling_tagging_limit_dbh != "" && sapling_tagging_limit_dbh > 12 { log_err("warning"); print "sapling_tagging_limit_dbh in " FILENAME " line " NR " should be less than 12 and was " sapling_tagging_limit_dbh " " RS $0 RS; } 
action == "validate" && NR > 1 && sapling_tagging_limit_height && !is_numeric(sapling_tagging_limit_height) { log_err("warning"); print "Field sapling_tagging_limit_height in " FILENAME " line " NR " should be a numeric but was " sapling_tagging_limit_height " " RS $0 RS; } 
action == "validate" && NR > 1 && sapling_tagging_limit_height != "" && sapling_tagging_limit_height < 1.3 { log_err("warning"); print "sapling_tagging_limit_height in " FILENAME " line " NR " should be greater than 1.3 and was " sapling_tagging_limit_height " " RS $0 RS; } 
action == "validate" && NR > 1 && sapling_tagging_limit_height != "" && sapling_tagging_limit_height > 20 { log_err("warning"); print "sapling_tagging_limit_height in " FILENAME " line " NR " should be less than 20 and was " sapling_tagging_limit_height " " RS $0 RS; } 
action == "validate" && NR > 1 && regen_plot_area && !is_numeric(regen_plot_area) { log_err("warning"); print "Field regen_plot_area in " FILENAME " line " NR " should be a numeric but was " regen_plot_area " " RS $0 RS; } 
action == "validate" && NR > 1 && regen_plot_area != "" && regen_plot_area < 0 { log_err("warning"); print "regen_plot_area in " FILENAME " line " NR " should be greater than 0 and was " regen_plot_area " " RS $0 RS; } 
action == "validate" && NR > 1 && regen_plot_area != "" && regen_plot_area > 2500 { log_err("warning"); print "regen_plot_area in " FILENAME " line " NR " should be less than 2500 and was " regen_plot_area " " RS $0 RS; } 
action == "validate" && NR > 1 && regen_plot_shape != "" && regen_plot_shape !~ /^(C|R|S)$/ { log_err("warning"); print "regen_plot_shape in " FILENAME " line " NR " should match the following pattern /^(C|R|S)$/ and was " regen_plot_shape " " RS $0 RS; } 
action == "validate" && NR > 1 && regen_tagging_limit_conifer && !is_numeric(regen_tagging_limit_conifer) { log_err("warning"); print "Field regen_tagging_limit_conifer in " FILENAME " line " NR " should be a numeric but was " regen_tagging_limit_conifer " " RS $0 RS; } 
action == "validate" && NR > 1 && regen_tagging_limit_conifer != "" && regen_tagging_limit_conifer < 0.1 { log_err("warning"); print "regen_tagging_limit_conifer in " FILENAME " line " NR " should be greater than 0.1 and was " regen_tagging_limit_conifer " " RS $0 RS; } 
action == "validate" && NR > 1 && regen_tagging_limit_conifer != "" && regen_tagging_limit_conifer > 1.3 { log_err("warning"); print "regen_tagging_limit_conifer in " FILENAME " line " NR " should be less than 1.3 and was " regen_tagging_limit_conifer " " RS $0 RS; } 
action == "validate" && NR > 1 && regen_tagging_limit_decid && !is_numeric(regen_tagging_limit_decid) { log_err("warning"); print "Field regen_tagging_limit_decid in " FILENAME " line " NR " should be a numeric but was " regen_tagging_limit_decid " " RS $0 RS; } 
action == "validate" && NR > 1 && regen_tagging_limit_decid != "" && regen_tagging_limit_decid < 0.1 { log_err("warning"); print "regen_tagging_limit_decid in " FILENAME " line " NR " should be greater than 0.1 and was " regen_tagging_limit_decid " " RS $0 RS; } 
action == "validate" && NR > 1 && regen_tagging_limit_decid != "" && regen_tagging_limit_decid > 1.3 { log_err("warning"); print "regen_tagging_limit_decid in " FILENAME " line " NR " should be less than 1.3 and was " regen_tagging_limit_decid " " RS $0 RS; } 
action == "validate" && NR > 1 && number_regen_plots && !is_numeric(number_regen_plots) { log_err("warning"); print "Field number_regen_plots in " FILENAME " line " NR " should be a numeric but was " number_regen_plots " " RS $0 RS; } 
action == "validate" && NR > 1 && number_regen_plots != "" && number_regen_plots < 0 { log_err("warning"); print "number_regen_plots in " FILENAME " line " NR " should be greater than 0 and was " number_regen_plots " " RS $0 RS; } 
action == "validate" && NR > 1 && number_regen_plots != "" && number_regen_plots > 10 { log_err("warning"); print "number_regen_plots in " FILENAME " line " NR " should be less than 10 and was " number_regen_plots " " RS $0 RS; } 
action == "validate" && NR > 1 && shrub_cover && !is_numeric(shrub_cover) { log_err("warning"); print "Field shrub_cover in " FILENAME " line " NR " should be a numeric but was " shrub_cover " " RS $0 RS; } 
action == "validate" && NR > 1 && shrub_cover != "" && shrub_cover !~ /^(0|5|10|15|20|25|30|35|40|45|50|55|60|65|70|75|80|85|90|95|100)$/ { log_err("warning"); print "shrub_cover in " FILENAME " line " NR " should match the following pattern /^(0|5|10|15|20|25|30|35|40|45|50|55|60|65|70|75|80|85|90|95|100)$/ and was " shrub_cover " " RS $0 RS; } 
action == "validate" && NR > 1 && herb_forb_cover && !is_numeric(herb_forb_cover) { log_err("warning"); print "Field herb_forb_cover in " FILENAME " line " NR " should be a numeric but was " herb_forb_cover " " RS $0 RS; } 
action == "validate" && NR > 1 && herb_forb_cover != "" && herb_forb_cover !~ /^(0|5|10|15|20|25|30|35|40|45|50|55|60|65|70|75|80|85|90|95|100)$/ { log_err("warning"); print "herb_forb_cover in " FILENAME " line " NR " should match the following pattern /^(0|5|10|15|20|25|30|35|40|45|50|55|60|65|70|75|80|85|90|95|100)$/ and was " herb_forb_cover " " RS $0 RS; } 
action == "validate" && NR > 1 && grass_cover && !is_numeric(grass_cover) { log_err("warning"); print "Field grass_cover in " FILENAME " line " NR " should be a numeric but was " grass_cover " " RS $0 RS; } 
action == "validate" && NR > 1 && grass_cover != "" && grass_cover !~ /^(0|5|10|15|20|25|30|35|40|45|50|55|60|65|70|75|80|85|90|95|100)$/ { log_err("warning"); print "grass_cover in " FILENAME " line " NR " should match the following pattern /^(0|5|10|15|20|25|30|35|40|45|50|55|60|65|70|75|80|85|90|95|100)$/ and was " grass_cover " " RS $0 RS; } 
action == "validate" && NR > 1 && moss_lichen_cover && !is_numeric(moss_lichen_cover) { log_err("warning"); print "Field moss_lichen_cover in " FILENAME " line " NR " should be a numeric but was " moss_lichen_cover " " RS $0 RS; } 
action == "validate" && NR > 1 && moss_lichen_cover != "" && moss_lichen_cover !~ /^(0|5|10|15|20|25|30|35|40|45|50|55|60|65|70|75|80|85|90|95|100)$/ { log_err("warning"); print "moss_lichen_cover in " FILENAME " line " NR " should match the following pattern /^(0|5|10|15|20|25|30|35|40|45|50|55|60|65|70|75|80|85|90|95|100)$/ and was " moss_lichen_cover " " RS $0 RS; } 

# sanitize rules
action ~ /^(sanitize|insert)$/ && NR > 1 {
    if (regen_tagging_limit_decid == "") $21 = "-9999"
    if (measurement_year == "") $4 = "-9999"
    if (regen_plot_shape == "") $19 = "NA"
    if (moss_lichen_cover == "") $29 = "NA"
    if (number_regen_plots == "") $22 = "-9999"
    if (stand_type == "") $9 = "NA"
    if (measurement_day == "") $6 = "-9999"
    if (plot_measurement_comment == "") $31 = "NA"
    if (avi_field_call == "") $30 = "NA"
    if (sapling_plot_area == "") $14 = "-9999"
    if (sapling_plot_shape == "") $15 = "NA"
    if (plot_type == "") $8 = "NA"
    if (regen_tagging_limit_conifer == "") $20 = "-9999"
    if (contractor == "") $23 = "NA"
    if (grass_cover == "") $28 = "NA"
    if (measurement_number == "") $3 = "NA"
    if (company_plot_number == "") $2 = "NA"
    if (shrub_cover == "") $26 = "NA"
    if (tree_tagging_limit == "") $13 = "-9999"
    if (plot_status == "") $10 = "NA"
    if (sapling_tagging_limit_dbh == "") $16 = "-9999"
    if (measurement_month == "") $5 = "-9999"
    if (cruiser_1_name == "") $24 = "NA"
    if (cruiser_2_name == "") $25 = "NA"
    if (stand_origin == "") $7 = "NA"
    if (tree_plot_shape == "") $12 = "NA"
    if (tree_plot_area == "") $11 = "-9999"
    if (herb_forb_cover == "") $27 = "NA"
    if (company == "") $1 = "NA"
    if (sapling_tagging_limit_height == "") $17 = "-9999"
    if (regen_plot_area == "") $18 = "-9999"
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
     print "CREATE TABLE IF NOT EXISTS  (number_regen_plots numeric,company_plot_number text,contractor text,measurement_number text,cruiser_1_name text,measurement_year numeric,cruiser_2_name text,measurement_month numeric,shrub_cover text,measurement_day numeric,herb_forb_cover text,stand_origin text,grass_cover text,plot_type text,moss_lichen_cover text,stand_type text,plot_status text,tree_plot_area numeric,tree_plot_shape text,tree_tagging_limit numeric,sapling_plot_area numeric,sapling_plot_shape text,sapling_tagging_limit_dbh numeric,sapling_tagging_limit_height numeric,regen_plot_area numeric,regen_plot_shape text,avi_field_call text,plot_measurement_comment text,regen_tagging_limit_conifer numeric,regen_tagging_limit_decid numeric,company text);"
}
action == "sanitize" { print }

# la fin
END {
    if (action == "insert") print "\\."
    if (action == "validate" && options["summary"] == "true") { print RS "violation summary: " RS "   counts:   " RS "      total: " err_count; print_cats(cats); }
}