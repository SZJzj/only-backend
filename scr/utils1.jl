import FinanceCore.rate
using ActuaryUtilities: present_value, irr, breakeven
using OrderedCollections: OrderedDict

include("structs1.jl")

"""
光伏发电总功率输出
"""
outputEnergy(pv::PhotovoltaicPanel) = @. pv.pv_number*pv.pv_refpower*(pv.input_solar/1000)*(1+pv.pv_alpha*(pv.ref_T+pv.pv_T))

"""
风机输出总功率
"""
function outputEnergy(wt::WindTurbine)
	wt.wt_ws = wt.input_ws*(wt.wt_h/wt.input_h)^0.14
	if wt.wt_ws<wt.wt_cutinws || wt.wt_ws>wt.wt_cutoffws
		outputpower = 0
	else if wt.wt_ws>=wt.wt_cutinws || wt.wt_ws<wt.wt_refws
		outputpower = wt.wt_number*wt.wt_refpower*(wt.wt_ws-wt.wt_cutinws)/(wt.wt_refws-wt.wt_cutinws)
	else if wt.wt_ws>=wt.wt_refws || wt.wt_ws<=wt.wt_cutoffws
		outputpower = wt.wt_number*wt.wt_refpower
	end
	return outputpower
end

"""
燃气轮机输出功率
"""
outputEnergy(gt::GasTurbine) = @. gt.gt_η*gt.input_power


"""
燃料电池输出功率
"""
function outputEnergy(fc::FuelCell)
	epower = -1.2645+0.0034*fc.input_T+140.3867*fc.input_power
	hpower = 1.2645-0.0034*fc.input_T+30.9707*fc.input_power
	return epower,hpower
end

"""
电解槽氢气产生率
"""
outputHydrogen(ec::ElectrolyticCell) = @. 0.0046+7.0564e-5*ec.input_T+0.0030*ec.input_i*ec.input_u

"""
光伏建设成本
"""
costConstruct(pv::PhotovoltaicPanel) = @. pv.cost_construct*pv.pv_number
"""
风机建设成本
"""
costConstruct(wt::WindTurbine)= @. wt.cost_cosntruct*wt.wt_number
"""
汽轮机建设成本
"""
costConstruct(gt::GasTurbine)= @. gt.cost_construct+ gt.gt_number
"""
电解槽建设成本
"""
costConstruct(ec::ElectrolyticCell)= @. ec.cost_construct+ ec.ec_number
"""
燃料电池建设成本
"""
costConstruct(fc::FuelCell)= @. fc.cost_construct+ fc.fc_number
"""
储氢罐建设成本
"""
costConstruct(ht::HydrogenTank)= @. ht.cost_construct+ ht.ht_number
"""
逆变器建设成本
"""
costConstruct(r::Rectifier)= @. r.cost_construct+ r.r_number
"""
总建设成本
"""
costConstruct(pv::PhotovoltaicPanel, wt::WindTurbine, gt::GasTurbine, ec::ElectrolyticCell,
fc::FuelCell, ht::HydrogenTank, r::Rectifier)=
costConstruct(pv)+costConstruct(wt)+costConstruct(gt)+costConstruct(ec)+costConstruct(fc)+costConstruct(ht)+costConstruct(r)

"""
光伏维护成本
"""
costMaintenance(pv::PhotovoltaicPanel) = @. pv.cost_maintenance*pv.pv_number*pv.running_year
"""
风机维护成本
"""
costMaintenance(wt::WindTurbine) = @. wt.cost_maintenance*wt.wt_number*wt.running_year
"""
燃气轮机维护成本
"""
costMaintenance(gt::GasTurbine) = @. gt.cost_maintenance*gt.gt_number*gt.running_year

"""
电解槽维护成本
"""
costMaintenance(ec::ElectrolyticCell) = @. ec.cost_maintenance*ec.ec_number*ec.running_year

"""
燃料电池维护成本
"""
costMaintenance(fc::FuelCell) = @. fc.cost_maintenance*fc.fc_number*fc.running_year

"""
储氢罐维护成本
"""
costMaintenance(ht::HydrogenTank) = @. ht.cost_maintenance*ht.ht_number*ht.running_year

"""
逆变器维护成本
"""
costMaintenance(r::Rectifier) = @. r.cost_maintenance*r.r_number*r.running_year

"""
维护总成本
"""
costMaintenance(pv::PhotovoltaicPanel, wt::WindTurbine, gt::GasTurbine, ec::ElectrolyticCell,
fc::FuelCell, ht::HydrogenTank, r::Rectifier)=
costMaintenance(pv)+costMaintenance(wt)+costMaintenance(gt)+costMaintenance(ec)+costMaintenance(fc)+costMaintenance(ht)+costMaintenance(r)

"""
光伏建设成本
"""
costAnnual(pv::PhotovoltaicPanel) = (costConstruct(pv)+costMaintenance(pv))/pv.running_year

"""
风机建设成本
"""
costAnnual(wt::WindTurbine)= (costConstruct(wt)+costMaintenance(wt))/wt.running_year

"""
汽轮机建设成本
"""
costAnnual(gt::GasTurbine)= (costConstruct(gt)+costMaintenance(gt))/gt.running_year

"""
电解槽建设成本
"""
costAnnual(ec::ElectrolyticCell)= (costConstruct(ec)+costMaintenance(ec))/ec.running_year

"""
燃料电池建设成本
"""
costAnnual(fc::FuelCell)= (costConstruct(fc)+costMaintenance(fc))/fc.running_year

"""
储氢罐建设成本
"""
costAnnual(ht::HydrogenTank)= (costConstruct(ht)+costMaintenance(ht))/ht.running_year

"""
逆变器建设成本
"""
costAnnual(r::Rectifier)= (costConstruct(r)+costMaintenance(r))/r.running_year

"""
总建设成本
"""
costAnnual(pv::PhotovoltaicPanel, wt::WindTurbine, gt::GasTurbine, ec::ElectrolyticCell,
fc::FuelCell, ht::HydrogenTank, r::Rectifier)=
costAnnual(pv)+costAnnual(wt)+costAnnual(gt)+costAnnual(ec)+costAnnual(fc)+costAnnual(ht)+costAnnual(r)














