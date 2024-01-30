abstract type RenewableEnergyMachine end

"""
光伏发电板

组件参数
pv_number光伏板数量
pv_refpower单个光伏板的额定输出功率（与光伏板相关）,kW
input_solar太阳辐射的光照强度（通过气象数据可得）,W/m^2
λ辐射温度系数（取0.0256）
pv_T光伏板实际温度（可求）,K
ref_T标准环境温度 （取293.15K）, 标准环境温度是指在标准大气压下（101.325千帕），空气的温度为20摄氏度
input_T实际环境温度 （通过气象数据可得）,K
pv_alpha功率温度调节系数（与光伏板相关）
cost_construct单个光伏板的建设成本（与光伏板相关），元
cost_maintenance单个光伏板年维护成本（与光伏板相关），元/年
running_year运行年限，年
pv_maxpower单个光伏板最大输出功率，kM

"""
Base.@kwdef mutable struct PhotovoltaicPanel <: RenewableEnergyMachine
	pv_number::Int64 = 5e5
	pv_refpower::Float64 = 1.0
	input_solar::Vector = Float64[]
	pv_T::Float64 = input_T+0.0256*input_solar
	ref_T::Float64 = 293.15
	input_T::Vector = Float64[]
	pv_alpha::Float64 = -0.05/100
	cost_construct::Float64 = 4000.0
	cost_maintenance::Float64 = 200.0
	running_year::Float64 = 10.0
	pv_maxpower::Float64 = 2.0
end


"""
风力发电机

wt_refpower单个风机的额定功率,kW
wt_number风机数量
wt_ws风机安装高度的风速（通过计算得到）,m/s
wt_cutinws切入风速（与风机相关）,m/s
wt_refws额定风速（与风机相关）,m/s
wt_cutoffws截止风速（与风机相关）,m/s
wt_h风机安装高度（与风机和设计相关）,m
input_h风速测量高度（通过气象数据可得）,m
input_ws测量风速（通过气象数据可得）,m/s
cost_construct单个风机建设成本（与风机相关），元
cost_maintenance单个风机年维护成本（与风机相关），元/年
running_year运行年限，年

"""

Base.@kwdef mutable struct WindTurbine <: RenewableEnergyMachine
	wt_refpower::Float64 = 5e4
	wt_number::Int64 = 1
	wt_ws::Float64 = 0.0
	wt_cutinws::Float64 = 3.0
	wt_refws::Float64 = 10.0
	wt_cutoffws::float64 = 30.0
	wt_h::Float64 = 100.0
	input_h::Float64 = 100.0
	input_ws::Vector = Float64[]
	cost_cosntruct::Float64 = 8e8
	cost_maintenance::Float64 = 5e5
	running_year::Float64 = 10.0
end

"""
燃气轮机

组件参数
gt_number燃气轮机数量
input_power燃气轮机消耗的燃料率,mol/s
gt_η气轮机综合发电效率（与燃气轮机相关）
cost_construct单个燃气轮机建设成本（与燃气轮机相关），元
cost_maintenance单个燃气轮机年维护成本（与燃气轮机相关），元/年
running_year运行年限，年
gt_maxpower单个燃气轮机最大输出功率，kM
"""

Base.@kwdef mutable struct GasTurbine <: RenewableEnergyMachine
	gt_number::Int64 = 1
	input_power::Float64 = 0.0
	gt_η::Float64 = 0.4
	cost_construct::Float64 = 2e7
	cost_maintenance::Float64 = 1e4
	running_year::Float64 = 10.0
	gt_maxpower::Float64 = 30000.0
end

"""
电解槽ec

组件参数
ec_number电解槽数量
input_u电解槽电压，V
input_i电解槽电流, A
input_T运行温度（输入）,T
cost_construct单个电解槽建设成本，元
cost_maintenance单个电解槽维护成本，元/年
running_year运行年限，年
"""
Base.@kwdef mutable struct ElectrolyticCell <: RenewableEnergyMachine
	ec_number::Int64 = 1
	input_u::Float64 = 0
	input_i::Float64 = 0
	input_T::Float64 = 297.15
	cost_contruct::Float64 = 5e4
	cost_mainentance::Float64 = 5e3
	running_year::Float64 = 10.0
end

"""
燃料电池fc

组件参数

fc_number燃料电池数量
fc_epower输出电功率（通过计算可得）.kW
fc_tpower输出热功率（通过计算可得）,kW
input_power消耗氢气速率（和燃料电池相关），mol/s
input_T运行温度（输入）,K
cost_construct单个燃料电池建设成本，元
cost_maintenance单个燃料电池年维护成本，元/年
running_year运行年限，年
"""

Base.@kwdef mutable struct FuelCell <: RenewableEnergyMachine
	fc_number::Int64 = 1
	fc_epower::Float64 = 0.0
	fc_tpower::Float64 = 0.0
	input_power::Float64 = 0.0
	input_T::Float64 = 297.15
	cost_construct::Float64 = 5e3
	cost_maintenance::Float64 = 5e2
	running_year::Float64 = 10.0
end

"""
储氢罐ht

组件参数

ht_numebr储氢罐数量
ht_pressure储氢罐压力，Pa
ht_volume单个储氢罐体积（与储氢罐相关）,m^3
input_T储氢罐温度（输入）,K
ht_in储氢罐进口速率，mol/h
ht_out储氢罐出口速率,mol/h
ht_maxpressure储氢罐最大压力（与储氢罐有关），Pa
ht_minpressure储氢罐最小压力（与储氢罐有关），Pa
ht_hcapacity储氢罐中氢气物质的量（通过计算可得），mol
cost_construct单个储氢罐建设成本，元
cost_maintenance单个储氢罐年维护成本，元/年
running_year运行年限，年
Δt单位时间，h
"""

Base.@kwdef mutable struct HydrogenTank <: RenewableEnergyMachine
	ht_number::Int64 = 1
	ht_pressure::Float64 = ht_minpressure
	ht_volume::Float64 = 3e3
	input_T::Float64 = 297.15
	ht_in::Float64 = 0.0
	ht_out::Float64 = 0.0
	ht_maxpressure::Float64 = 3e4
	ht_minpressure::Float64 = 1e4
	ht_hcapacity::Float64 = 0.0
	cost_construct::Float64 = 2e4
	cost_maintenance::Float64 = 2e3
	running_year::Float64 = 10.0
	Δt::Float64 = 1.0
end

"""
整流器/逆变器

组件参数

r_number逆变器数量
η综合效率（考虑逆变器、电机等效率综合，与设备有关）
input_power输入功率，kW
output_power输出功率，kW
cost_construct单个逆变器建设成本，元
cost_maintenance单个逆变器年维护成本，元/年
running_year运行年限，年
"""

Base.@kwdef mutable struct Rectifier <: RenewableEnergyMachine
	r_number::Int64 = 1
	η::Float64 = 0.8
	input_power::Float64 = 0.0
	output_power::Float64 = 0.0
	cost_construct::Float64 = 2e4
	cost_maintenance::Float64 = 2e3
	running_year::Float64 = 10.0
end
