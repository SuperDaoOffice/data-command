use "F:\数据\CLASS\CLASS2020.dta" ,clear
*基本变量
recode A1 (2=0 "女性") (1=1 "男性"),gen(gender)
label var gender "性别"
tab gender
destring A2_1_open ,force gen(birth)
sum birth
label var birth "出生日期"
gen age=2020-birth
label var age "年龄"
recode A3 (1=1 "不识字") (2 3=2 "私塾/扫盲班/小学") (4=3 "初中")(5 6 7=4 "高中及以上"),gen(edu)
label var edu"受教育水平"
recode A3 (1=0)(2 3=6)(4=9)(5=12)(6=15)(7=16),gen(eduy)
label var eduy "受教育年限"
recode A5 (1=1 "已婚")(else=0 "丧偶/离异/未婚"),gen(marry)
label var marry "婚姻"
recode A10 (1=0 "农业")(else=1 "非农业"),gen(hukou)
label var hukou "户籍"
recode B1(5=1 "很不健康")(4=2 "比较不健康")(3=3 "一般")(2=4 "比较健康") (1=5 "很健康")(9=.),gen(selfrate)
label var selfrate "自评健康"
foreach i of numlist 3/5 9 10 11 {
recode B4_`i' (1=1)(2 3=0),gen (z`i')
}
sum z3 z4 z5 z9 z10 z11
egen adl= rowtotal( z3 z4 z5 z9 z10 z11 )
label var adl "日常活动能力"
drop z3 z4 z5 z9 z10 z11
recode A8_1_open (1=1 "独居")(else=0 "非独居"),gen(livealone)
label var livealone "独居"
foreach i of numlist 1/23 {
recode B9_1_`i' (1=1)(2=0),gen (z`i')
}
sum z1-z23
egen chronic= rowtotal(z1-z23)
drop z1-z23
label var chronic "慢病数量"
tab chronic
recode chronic (0=0 "否")(else=1 "是"),gen(chronic1)
label var chronic1 "是否患慢病"
recode B17(5=1 "很不满意")(4=2 "比较不满意")(3=3 "一般")(2=4 "比较满意") (1=5 "很满意"),gen(lifesati)
tab lifesati
replace lifesati=. if lifesati==9
label var lifesati "生活满意度"
recode C1 (5=0 "未工作")(else=1 "从事工作"),gen(work)
label var work "从事有收入工作"
foreach i of numlist 1/8 {
recode D2_1_`i' (1=1)(2=0),gen (z`i')
}
sum z1-z8
egen security= rowtotal(z1-z8)
drop z1-z8
label var security "享受社会保障待遇数量"
recode security (0=0 "否")(else=1 "是"),gen(security1)
label var security1 "享受社会保障待遇"
foreach i of numlist 1/3 {
recode D2_1_`i' (1=1)(2=0),gen (z`i')
}
egen pen= rowtotal(z1-z3)
recode pen (0=0 "否")(else=1 "是"),gen(pension)
drop z1-z3
label var pension "享受养老保险"
recode D12_5 (0=0 )(1=1 )(2=2 )(3=3 ) (4=5) (5=9),gen(friend)
label var friend "一个月能和几个朋友见面"
recode D17 (1=1 "是")(2=0 "否"),gen(wifi)
label var wifi "房屋有网络信号/无线"
recode D18 (5=0 "否")(else=1 "是"),gen(internet)
label var internet "是否上网"
recode D18(5=1 "从不上网")(4=2 "每年上几次")(3=3 "每月至少上一次")(2=4 "每星期至少上一次") (1=5 "每天都上"),gen(interuse)
label var interuse "上网频次"
clonevar inter = D21_5
label var inter "过去三个月互联网使用情况"
foreach i of numlist 1/4 {
recode E5_`i' (1=5)(2=4)(3=3)(4=2)(5=1)(9=.),gen (z`i')
}
sum z1-z4
gen ownaging= z1+z2+z3+z4
label var own "自我老化态度"
drop z1-z4
foreach i of numlist 5/7 {
gen z`i'=E5_`i'
replace z`i'=. if z`i'==9
}
gen normaging= z5+z6+z7
label var norm "一般老化态度"
drop z5-z7
gen aging=own+norm
sum aging
label var aging "老化态度"
foreach i of numlist 1/4 {
gen z`i'=E6_`i'
replace z`i'=. if z`i'==9
}
sum z1-z4
gen self= z1+z2+z3+z4
sum self
label var self "个人发展适应"
foreach i of numlist 5/8 {
recode E6_`i' (1=5)(2=4)(3=3)(4=2)(5=1)(9=.),gen (z`i')
}
sum z5-z8
gen adopt= z5+z6+z7+z8
label var adopt "精神文化适应"
drop z1 z2 z3 z4 z5 z6 z7 z8
gen medi= self+adopt
label var medi "总社会适应"
sum medi
clonevar childnum = F5_1_open
replace childnum =0 if  F4_1_open==0& F4_2_open==0
replace childnum =0 if  F4_1_1_open ==0& F4_1_2_open ==0
label var childnum "健在子女数"
clonevar pincome = C10_1_1_open
label var pincome "个人收入"
clonevar income = C10_2_1_open
label var pincome "家庭收入"
tab D3_1_open
recode D3_1_open (0=0 "无")(1=1 "1套")(else=2 "2套及以上"),gen(house)
label var house "所有房屋"
recode Q5a (5=1 "农村")(else=0 "城镇"),gen(rural)
label var rural "居住地类型"
tab rural
encode Q3_1 , generate(province)
label var province "省份"
egen famnet=rowtotal( D12_1 D12_2 D12_3 )
lab var fam "家庭社会网络"
egen frinet=rowtotal( D12_4 D12_5 D12_6 )
lab var frin "朋友社会网络"
recode D11_7 (0=1 "有") (1=0 "无"),gen(facility)
label var facility "社区有文娱活动/设施"
clonevar cog = E1_9_1_open
label var cog "认知能力"
gen net= famnet+ frinet
lab var net "社会网络"
gen age2=age^2
recode adl (6=1 "是")(else=0 "否"),gen (nadl)
lab var nadl "日常活动能力健全"
recode chronic (0=0 "无")(1=1 "一种")(2=2 "两种")(else=3 "三种及以上"),gen (chronic3)
lab var chronic3 "慢性病数量分组"
tab1 E5_2 E5_7
recode E5_2  (1=5 "完全不同意")(2=4 "有点不同意")(3=3 "无所谓")(4=2 "有点同意")(5=1 "完全同意")(9=.),gen (phy)
lab var phy "生理老化（在我看来，变老就是一个不断失去的过程）"
gen psy= E5_7
replace psy=. if psy==9
label copy E5_7 psy
label values psy psy
lab var psy "心理老化（变老也有许多令人愉快的事）"
tab1 phy psy
sum birth
recode birth (1922/1930=1 "1921-1930")(1931/1940=2 "1931-1940")(1941/1950=3 "1941-1950")(1951/1960=4 "1951-1960"),gen(cohort)
lab var cohort "出生队列"
recode cohort (1 2=1 "-1940") (3=2 "1941-1950") (4=3 "1951-1960"),gen(cohort1)
tab cohort1
lab var cohort1 "出生队列"
bysort Q2_1_open :egen Total_inter=total( internet )      
bysort Q2_1_open : gen Mean_inter =(Total_inter- internet )/(_N-1)
sum  Mean_inter
drop if missing(internet,interuse, aging, medi, Mean_inter, selfrate )
sum gender
sum ownaging normaging aging internet  inter age gender marry eduy selfrate livealone childnum security1  rural medi self adopt Mean_inter
asdoc sum ownaging normaging aging internet  inter age gender marry eduy selfrate livealone childnum security1  rural medi self adopt Mean_inter
tab internet
tab gender
tab marry
tab selfrate
tab live
tab security1
tab rural
asdoc reg ownaging i.internet age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province,r append
asdoc reg normaging i.internet age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province,r append
asdoc reg aging i.internet age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province,r append
eregress aging age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province, endogenous(internet = age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province  Mean_inter , probit)
 eregress ownaging age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province, endogenous(internet = age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province  Mean_inter , probit)
 eregress normaging age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province, endogenous(internet = age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province  Mean_inter , probit)
ivreg2 aging ( internet = Mean_inter )age i.gender i.marry eduy i.selfrate  i.livealone  childnum i.security1 i.rural i.province , first r
ivregress 2sls aging ( internet = Mean_inter )age i.gender i.marry eduy i.selfrate  i.livealone  childnum i.security1 i.rural i.province , first r
estat endogenous
ivreg2 ownaging ( internet = Mean_inter )age i.gender i.marry eduy i.selfrate  i.livealone  childnum i.security1 i.rural i.province , first r
ivregress 2sls ownaging ( internet = Mean_inter )age i.gender i.marry eduy i.selfrate  i.livealone  childnum i.security1 i.rural i.province , first r
estat endogenous
ivreg2 normaging ( internet = Mean_inter )age i.gender i.marry eduy i.selfrate  i.livealone  childnum i.security1 i.rural i.province , first r
ivregress 2sls normaging ( internet = Mean_inter )age i.gender i.marry eduy i.selfrate  i.livealone  childnum i.security1 i.rural i.province , first r
estat endogenous
foreach i of numlist 1/4 {
recode E5_`i' (1=5)(2=4)(3=3)(4=2)(5=1)(9=.),gen (z`i')
}
foreach i of numlist 5/7 {
gen z`i'=E5_`i'
replace z`i'=. if z`i'==9
}
pca z1 z2 z3 z4 z5 z6 z7
factor z1 z2 z3 z4 z5 z6 z7,pcf
factortest z1 z2 z3 z4 z5 z6 z7
 rotate, promax(3) factors(2)
predict f1 f2
gen score=(f1*0.2759+f2*0.2197)/(0.2759+0.2197)
reg f1 i.internet age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province,r
reg f2 i.internet age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province,r
reg score i.internet age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province,r
reg ownaging i.inter age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province,r
reg normaging i.inter age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province,r
reg aging i.inter age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province,r
sum cog
reg ownaging i.internet age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province if cog>13.66321,r
reg normaging i.internet age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province if cog>13.66321,r
reg aging i.internet age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.rural  i.province if cog>13.66321,r
tab selfrate, gen(selfrate_dum)
tab  province, gen( province_dum)
sgmediation2 ownaging , mv( medi) iv( internet ) cv( age  eduy childnum gender marry selfrate_dum1 selfrate_dum2 selfrate_dum3 selfrate_dum4 livealone security1 rural province_dum1 province_dum2 province_dum3 province_dum4 province_dum5 province_dum6 province_dum7 province_dum8 province_dum9 province_dum10 province_dum11 province_dum12 province_dum13 province_dum14 province_dum15 province_dum16 province_dum17 province_dum18 province_dum19 province_dum20 province_dum21 province_dum22 province_dum23 province_dum24 province_dum25 province_dum26 province_dum27)
sgmediation2 normaging , mv( medi) iv( internet ) cv( age  eduy childnum gender marry selfrate_dum1 selfrate_dum2 selfrate_dum3 selfrate_dum4 livealone security1 rural province_dum1 province_dum2 province_dum3 province_dum4 province_dum5 province_dum6 province_dum7 province_dum8 province_dum9 province_dum10 province_dum11 province_dum12 province_dum13 province_dum14 province_dum15 province_dum16 province_dum17 province_dum18 province_dum19 province_dum20 province_dum21 province_dum22 province_dum23 province_dum24 province_dum25 province_dum26 province_dum27)
sgmediation2 aging , mv( medi) iv( internet ) cv( age  eduy childnum gender marry selfrate_dum1 selfrate_dum2 selfrate_dum3 selfrate_dum4 livealone security1 rural province_dum1 province_dum2 province_dum3 province_dum4 province_dum5 province_dum6 province_dum7 province_dum8 province_dum9 province_dum10 province_dum11 province_dum12 province_dum13 province_dum14 province_dum15 province_dum16 province_dum17 province_dum18 province_dum19 province_dum20 province_dum21 province_dum22 province_dum23 province_dum24 province_dum25 province_dum26 province_dum27)
sgmediation2 aging , mv(self) iv( internet ) cv( age  eduy childnum gender marry selfrate_dum1 selfrate_dum2 selfrate_dum3 selfrate_dum4 livealone security1 rural province_dum1 province_dum2 province_dum3 province_dum4 province_dum5 province_dum6 province_dum7 province_dum8 province_dum9 province_dum10 province_dum11 province_dum12 province_dum13 province_dum14 province_dum15 province_dum16 province_dum17 province_dum18 province_dum19 province_dum20 province_dum21 province_dum22 province_dum23 province_dum24 province_dum25 province_dum26 province_dum27)
sgmediation2 aging , mv(adopt) iv( internet ) cv( age  eduy childnum gender marry selfrate_dum1 selfrate_dum2 selfrate_dum3 selfrate_dum4 livealone security1 rural province_dum1 province_dum2 province_dum3 province_dum4 province_dum5 province_dum6 province_dum7 province_dum8 province_dum9 province_dum10 province_dum11 province_dum12 province_dum13 province_dum14 province_dum15 province_dum16 province_dum17 province_dum18 province_dum19 province_dum20 province_dum21 province_dum22 province_dum23 province_dum24 province_dum25 province_dum26 province_dum27)
bootstrap r(tot_eff) r(dir_eff) r(ind_eff)  , reps(5000) :sgmediation2 ownaging , mv( medi) iv( internet ) cv( age  eduy childnum gender marry selfrate_dum1 selfrate_dum2 selfrate_dum3 selfrate_dum4 livealone security1 rural province_dum1 province_dum2 province_dum3 province_dum4 province_dum5 province_dum6 province_dum7 province_dum8 province_dum9 province_dum10 province_dum11 province_dum12 province_dum13 province_dum14 province_dum15 province_dum16 province_dum17 province_dum18 province_dum19 province_dum20 province_dum21 province_dum22 province_dum23 province_dum24 province_dum25 province_dum26 province_dum27)
bootstrap r(tot_eff) r(dir_eff) r(ind_eff) , reps(5000) :sgmediation2 normaging , mv( medi) iv( internet ) cv( age  eduy childnum gender marry selfrate_dum1 selfrate_dum2 selfrate_dum3 selfrate_dum4 livealone security1 rural province_dum1 province_dum2 province_dum3 province_dum4 province_dum5 province_dum6 province_dum7 province_dum8 province_dum9 province_dum10 province_dum11 province_dum12 province_dum13 province_dum14 province_dum15 province_dum16 province_dum17 province_dum18 province_dum19 province_dum20 province_dum21 province_dum22 province_dum23 province_dum24 province_dum25 province_dum26 province_dum27)
bootstrap r(tot_eff) r(dir_eff) r(ind_eff) , reps(5000) :sgmediation2 aging , mv( medi) iv( internet ) cv( age  eduy childnum gender marry selfrate_dum1 selfrate_dum2 selfrate_dum3 selfrate_dum4 livealone security1 rural province_dum1 province_dum2 province_dum3 province_dum4 province_dum5 province_dum6 province_dum7 province_dum8 province_dum9 province_dum10 province_dum11 province_dum12 province_dum13 province_dum14 province_dum15 province_dum16 province_dum17 province_dum18 province_dum19 province_dum20 province_dum21 province_dum22 province_dum23 province_dum24 province_dum25 province_dum26 province_dum27)
reg aging i.internet age i.gender i.marry eduy i.selfrate i.livealone childnum i.security1  i.province if cohort1==1,r
reg aging i.internet age i.gender i.marry eduy i.selfrate i.livealone childnum i.security1  i.province if cohort1==2,r
reg aging i.internet age i.gender i.marry eduy i.selfrate i.livealone childnum i.security1  i.province if cohort1==3,r
reg aging i.internet##i.rural age  i.gender i.marry eduy i.selfrate  i.livealone childnum i.security1  i.province ,r
sum internet
sum rural
gen inter1=internet*rural
correlate internet rural inter1, covariance
tab wifi rural
display  2313/3528
display  1096/2749
tab internet rural
display  1448/3528
display  476/2749
tab inter rural
display (628+484)/(3528-2042)
display (124+157)/(2749-2179)