package eu.quanticol.carma.core.tests

import com.google.inject.Inject
import eu.quanticol.carma.core.carma.Model
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import static extension org.junit.Assert.*
import eu.quanticol.carma.simulator.CarmaModel
import eu.quanticol.carma.simulator.CarmaSystem
import org.cmg.ml.sam.sim.sampling.StatisticSampling
import org.cmg.ml.sam.sim.sampling.SamplingCollection
import org.cmg.ml.sam.sim.SimulationEnvironment
import org.cmg.ml.sam.sim.sampling.SamplingFunction
import eu.quanticol.carma.simulator.CarmaPredicate
import eu.quanticol.carma.simulator.CarmaStore

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(CARMAInjectorProviderCustom))
class Test_NEW_SG {
	@Inject extension ParseHelper<Model>
	@Inject extension ValidationTestHelper	
	@Inject extension CompilationTestHelper
	
	CharSequence code = 	'''
//SuppliersSet={1, 2}, DemandersSet = {3, 4}
//LearnersSet = {l10, l13, l14, l20, l23, l24, l03, l04} --> index = [0..7]
record LSet = [ real l10, real l13, real l14, real l20,  real l23, real l24, real l03, real l04 ];
	
record MG = [ real m1, real m2, real m3, real m4 ];

const VOLTAGES = [ l10:=20.0, l13:=10.0, l14:=10.0, l20:=20.0, l23:=10.0, l24:=10.0, l03:=20.0, l04:=20.0 ];

const ALPHA = 50.0;

const RESISTORS = [ l10:=10.0, l13:=1.0, l14:=1.0, l20:=10.0, l23:=1.0, l24:=1.0, l03:=10.0, l04:=10.0 ];

const MAXPOWERS = [ l10:=300.0, l13:=300.0, l14:=300.0, l20:=200.0, l23:=300.0, l24:=400.0, l03:=375.0, l04:=450.0 ];

const ST = 10.0;

const DELTAPOWERS = [ l10 := 300.0/ST, l13:=300.0/ST, l14:=300.0/ST, l20:=200.0/ST, l23:=200.0/ST, l24:=200.0/ST, l03:=375.0/ST, l04:=450.0/ST ];

const MICROGRID = [ m1 := 300.0 , m2:=200.0, m3 :=-250.0, m4 := -300.0 ];

fun real ReturnVal(LSet vector, int idx){
	real value := 0.0;
	
	if (idx == 0) {value := vector.l10;}
	if (idx == 1) {value := vector.l13;}
	if (idx == 2) {value := vector.l14;}
	if (idx == 3) {value := vector.l20;}
	if (idx == 4) {value := vector.l23;}
	if (idx == 5) {value := vector.l24;}
	if (idx == 6) {value := vector.l03;}
	if (idx == 7) {value := vector.l04;}

	return value;
}

fun int UpdateVal(LSet vector, int idx, real p){
	
	if (idx == 0) {vector.l10 := p;}
	if (idx == 1) {vector.l13 := p;}
	if (idx == 2) {vector.l14 := p;}
	if (idx == 3) {vector.l20 := p;}
	if (idx == 4) {vector.l23 := p;}
	if (idx == 5) {vector.l24 := p;}
	if (idx == 6) {vector.l03 := p;}
	if (idx == 7) {vector.l04 := p;}

	return 1;
}

fun LSet PowerLoss(LSet newpowersvect){
	LSet pL := [ l10:=0.0, l13:=0.0, l14:=0.0, l20:=0.0, l23:=0.0, l24:=0.0, l03:=0.0, l04:=0.0 ]; //Power Loss
	LSet resistors := RESISTORS;
	LSet voltages := VOLTAGES;
	
	pL.l10 := resistors.l10*pow(newpowersvect.l10/voltages.l10, 2);
	pL.l13 := resistors.l13*pow(newpowersvect.l13/voltages.l13, 2);
	pL.l14 := resistors.l14*pow(newpowersvect.l14/voltages.l14, 2);
	pL.l20 := resistors.l20*pow(newpowersvect.l20/voltages.l20, 2);
	pL.l23 := resistors.l23*pow(newpowersvect.l23/voltages.l23, 2);
	pL.l24 := resistors.l24*pow(newpowersvect.l24/voltages.l24, 2);
	pL.l03 := resistors.l03*pow(newpowersvect.l03/voltages.l03, 2);
	pL.l04 := resistors.l04*pow(newpowersvect.l04/voltages.l04, 2);
	
	return pL;
}

fun LSet CalcCValues(LSet newpowersvect){
	LSet cvalues := [ l10:=0.0, l13:=0.0, l14:=0.0, l20:=0.0, l23:=0.0, l24:=0.0, l03:=0.0, l04:=0.0 ];
	LSet pL := [ l10:=0.0, l13:=0.0, l14:=0.0, l20:=0.0, l23:=0.0, l24:=0.0, l03:=0.0, l04:=0.0 ];
	pL := PowerLoss(newpowersvect);
	MG mgs := MICROGRID;
	
	cvalues.l10 := mgs.m1 - (newpowersvect.l13 + newpowersvect.l14);
	cvalues.l20 := mgs.m2 - (newpowersvect.l23 + newpowersvect.l24);
	cvalues.l03 := -1.0 * mgs.m3 - (newpowersvect.l13 + newpowersvect.l23) + pL.l03 + pL.l13 + pL.l23;
	cvalues.l04 := -1.0 * mgs.m4 - (newpowersvect.l14 + newpowersvect.l24) + pL.l04 + pL.l14 + pL.l24;
	cvalues.l13 := 0.5*(mgs.m1 - mgs.m3 - newpowersvect.l14 - newpowersvect.l23 - newpowersvect.l10 - newpowersvect.l03);// + 0.5*(pL.l03 + pL.l13 + pL.l23);
	cvalues.l23 := 0.5*(mgs.m2 - mgs.m3 - newpowersvect.l24 - newpowersvect.l13 - newpowersvect.l20 - newpowersvect.l03);// + 0.5*(pL.l03 + pL.l13 + pL.l23);
	cvalues.l14 := 0.5*(mgs.m1 - mgs.m4 - newpowersvect.l13 - newpowersvect.l24 - newpowersvect.l10 - newpowersvect.l04);// + 0.5*(pL.l04 + pL.l14 + pL.l24);
	cvalues.l24 := 0.5*(mgs.m2 - mgs.m4 - newpowersvect.l23 - newpowersvect.l14 - newpowersvect.l20 - newpowersvect.l04);// + 0.5*(pL.l04 + pL.l14 + pL.l24);
	
	return cvalues;
}

fun real StepFunc(real val) {
	real sf := 0.0;
	if (val >= 0.0) {
		sf := 1.0;
	}	
	return sf;
}


fun LSet CalcPayoffs(LSet newpowersvect){
	real tol := 15.0;
	real alpha := ALPHA;
	LSet cvalues := [ l10:=0.0, l13:=0.0, l14:=0.0, l20:=0.0, l23:=0.0, l24:=0.0, l03:=0.0, l04:=0.0 ];
	LSet payoffs := [ l10:=-1.0*alpha, l13:=-1.0*alpha, l14:=-1.0*alpha, l20:=-1.0*alpha, l23:=-1.0*alpha, l24:=-1.0*alpha, l03:=-1.0*alpha, l04:=-1.0*alpha ];
		
	cvalues := CalcCValues(newpowersvect);
	LSet maxpowers := MAXPOWERS;
	
	if ((cvalues.l10 >= 0) && (cvalues.l10 <= maxpowers.l10)){
		payoffs.l10 := -1.0*pow(abs(newpowersvect.l10 - cvalues.l10),0.5) + alpha*real(StepFunc(newpowersvect.l10 - cvalues.l10));
		if ((payoffs.l10 >= alpha-tol) || (payoffs.l10 < 0 && payoffs.l10 >= -1*tol)){
			payoffs.l10 := alpha;
		}
	} else {
		payoffs.l10 := -1.0*alpha;
	}
		
	if (cvalues.l13 >= 0 && cvalues.l13 <= maxpowers.l13){
		payoffs.l13 := -1.0*pow(abs(newpowersvect.l13 - cvalues.l13),0.5) + alpha*real(StepFunc(newpowersvect.l13 - cvalues.l13));
		if ((payoffs.l13 >= alpha-tol) || (payoffs.l13 < 0 && payoffs.l13 >= -1*tol)){
			payoffs.l13 := alpha;
		}
	} else {
		payoffs.l13 := -1.0*alpha;
	}
		
	if (cvalues.l14 >= 0 && cvalues.l14 <= maxpowers.l14){
		payoffs.l14 := -1.0*pow(abs(newpowersvect.l14 - cvalues.l14),0.5) + alpha*real(StepFunc(newpowersvect.l14 - cvalues.l14));
		if ((payoffs.l14 >= alpha-tol) || (payoffs.l14 < 0 && payoffs.l14 >= -1*tol)){
			payoffs.l14 := alpha;
		}	
	} else {
		payoffs.l14 := -1.0*alpha;
	}
		 
	if (cvalues.l20 >= 0 && cvalues.l20 <= maxpowers.l20) {
		payoffs.l20 := -1.0*pow(abs(newpowersvect.l20 - cvalues.l20),0.5) + alpha*real(StepFunc(newpowersvect.l20 - cvalues.l20));
		if ((payoffs.l20 >= alpha-tol) || (payoffs.l20 < 0 && payoffs.l20 >= -1*tol)){
			payoffs.l20 := alpha;
		}
	} else {
		payoffs.l20 := -1.0*alpha;
	}
		 
	if (cvalues.l23 >= 0 && cvalues.l23 <= maxpowers.l23) {
		payoffs.l23 := -1.0*pow(abs(newpowersvect.l23 - cvalues.l23),0.5) + alpha*real(StepFunc(newpowersvect.l23 - cvalues.l23));
		if ((payoffs.l23 >= alpha-tol) || (payoffs.l23 < 0 && payoffs.l23 >= -1*tol)){
			payoffs.l23 := alpha;
		}
	} else {
		payoffs.l23 := -1.0*alpha;//
	}
		  
	if (cvalues.l24 >= 0 && cvalues.l24 <= maxpowers.l24) {
		payoffs.l24 := -1.0*pow(abs(newpowersvect.l24 - cvalues.l24),0.5) + alpha*real(StepFunc(newpowersvect.l24 - cvalues.l24));
		if ((payoffs.l24 >= alpha-tol) || (payoffs.l24 < 0 && payoffs.l24 >= -1*tol)){
			payoffs.l24 := alpha;
		}
	} else {
		payoffs.l24 := -1.0*alpha;//
	}
		  
	if (cvalues.l03 >= 0 && cvalues.l03 <= maxpowers.l03) {
		payoffs.l03 := -1.0*pow(abs(newpowersvect.l03 - cvalues.l03),0.5) + alpha*real(StepFunc(newpowersvect.l03 - cvalues.l03));
		if ((payoffs.l03 >= alpha-tol) || (payoffs.l03 < 0 && payoffs.l03 >= -1*tol)) {
			payoffs.l03 := alpha;
		}
	} else {
		payoffs.l03 := -1.0*alpha;
	}
		  
	if (cvalues.l04 >= 0 && cvalues.l04 <= maxpowers.l04) {
		payoffs.l04 := -1.0*pow(abs(newpowersvect.l04 - cvalues.l04),0.5) + alpha*real(StepFunc(newpowersvect.l04 - cvalues.l04));
		if ((payoffs.l04 >= alpha-tol) || (payoffs.l04 < 0 && payoffs.l04 >= -1*tol)) { 
			payoffs.l04 := alpha;
		}
	} else {
		payoffs.l04 := -1.0*alpha;
	}
	
	return payoffs; 
}


fun int Greater(LSet vect1, LSet vect2) {
	int gt := 0;
	if  ((vect1.l10 >= vect2.l10) && 
	     (vect1.l13 >= vect2.l13) &&
	     (vect1.l14 >= vect2.l14) &&
		 (vect1.l20 >= vect2.l20) &&
		 (vect1.l23 >= vect2.l23) &&
		 (vect1.l24 >= vect2.l24) &&
		 (vect1.l03 >= vect2.l03) &&
		 (vect1.l04 >= vect2.l04)) {
		 	gt := 1;
		 }		 
	return gt;	 
}

fun real DecreaseP(int index, real p){
	real deltap := ReturnVal(DELTAPOWERS, index);
	real newp := (p-1.0-deltap) + deltap*RND;
	
	if (newp < 0) {newp := 0.0;}
	
	return newp;
}


fun real IncreaseP(int index, real p){
	real deltap := ReturnVal(DELTAPOWERS, index);
	real mp := ReturnVal(MAXPOWERS, index);     //maximum power of the learner
	real newp := (p+1.0) + deltap*RND;
	
	if (newp > mp) {newp := mp;}
	
	return newp;
}

component Learner(int index, real power, real rnd){
	store{
		attrib i := index;     //0..8 the index of the learner in LearnerSet
		attrib p := power;     //the current power level
		attrib l_ambda := rnd;
		attrib pf := -1.0*ALPHA;   //payoff
		attrib rng := 0.0;
	}
	
	behaviour{
		//RPP= Receive Powers and payoffs; GR: Generate random;  DU: Decide to update
		//UP==Update Power state;  SP==Send New Power state
		RPP = updatepower*(powers, payoffs_attrib){pf := ReturnVal(payoffs_attrib, my.i); p := ReturnVal(powers, my.i);}.GR;
		
		GR = generaterandom*{rng := RND;}.DU;   
		
		DU = [rng < l_ambda]samepower*.SP + [rng >= l_ambda]changeupdate*.UP;
		
		UP = [pf >= 0 && pf < ALPHA]decreasepower*{p := DecreaseP(my.i, my.p);}.SP
			 + [pf < 0 && pf > -1*ALPHA] increasepower*{p := IncreaseP(my.i, my.p);}.SP
			 + [pf == ALPHA || pf == -1*ALPHA]samepower*.SP;

		SP = sendpower<my.i, my.p>.RPP;
	}

	init{
		SP
	}	
}

component ComputingServer(){
	store{
		attrib a := 0;
		attrib rcvnum := 0;
		attrib stable := 0;
		attrib alphas := [ l10:=ALPHA, l13:=ALPHA, l14:=ALPHA, l20:=ALPHA, l23:=ALPHA, l24:=ALPHA, l03:=ALPHA, l04:=ALPHA ];
		attrib newpowers := [ l10:=0.0, l13:=0.0, l14:=0.0, l20:=0.0, l23:=0.0, l24:=0.0, l03:=0.0, l04:=0.0 ];
		attrib powers :=[ l10:=0.0, l13:=0.0, l14:=0.0, l20:=0.0, l23:=0.0, l24:=0.0, l03:=0.0, l04:=0.0 ];
		attrib newpayoffs := [ l10:=0.0, l13:=0.0, l14:=0.0, l20:=0.0, l23:=0.0, l24:=0.0, l03:=0.0, l04:=0.0 ];
		attrib payoffs := [ l10:=-ALPHA, l13:=-ALPHA, l14:=-ALPHA, l20:=-ALPHA, l23:=-ALPHA, l24:=-ALPHA, l03:=-ALPHA, l04:=-ALPHA ];
		attrib step := 0;
	}
	
	behaviour{
		//RP = Receive the new power of a learner State;   CP = Calculate Payoffs
		//InitS = Init. State; 
		RP = sendpower(i, p){a := UpdateVal(my.newpowers, i, p); rcvnum := rcvnum + 1; step := 1;}.CP;
		
		CP = [my.rcvnum < 8]waitalllearners*{step := 0;}.RP 
				+ [my.rcvnum == 8] calcpayoffs*{newpayoffs := CalcPayoffs(my.newpowers); rcvnum := 0; step := 2;}.NewPA;
				
		NewPA = newpayoffAlphas*{a := Greater(my.newpayoffs, alphas); step := 3;}.FS; 		
		
		FS = [a == 1]stablestate*{payoffs := newpayoffs; powers := newpowers; stable := 1;}.nil + [a == 0]continue*{ step := 4; }.NewPP;
		
		NewPP = newpayoffpayoff*{a := Greater(my.newpayoffs, payoffs); step := 5; }.DC; 
				
		DC = [a == 1]updatepower*<newpowers, newpayoffs>{step := 0 ; payoffs := newpayoffs; powers := newpowers; newpayoffs := [ l10:=0.0, l13:=0.0, l14:=0.0, l20:=0.0, l23:=0.0, l24:=0.0, l03:=0.0, l04:=0.0 ] ; newpowers := [ l10:=0.0, l13:=0.0, l14:=0.0, l20:=0.0, l23:=0.0, l24:=0.0, l03:=0.0, l04:=0.0 ]; }.RP 
				+ [a == 0]updatepower*<powers, payoffs>{ step := 0; }.RP;
	}
	
	init{
		RP
	}
}

//measure payoffs[ i := 0:7 ] = max{ ReturnVal(my.payoffs,i)  | true };
//measure powers[ i := 0:7 ] = max{ ReturnVal(my.powers,i)  | true };
//measure alpha[ i := 0:7] = max{ ReturnVal(my.alphas,i)  | true };
measure debug = #{ ComputingServer[FS] | my.a==1 };

system Simple{
    collective{
    	new Learner(0:7, 0.0, 0.0);
    	new ComputingServer();
    }

    environment{
    	
	    	prob{
	    		default { return 1.0; }
	    	}
	    	
	    rate{
	    		default { return 1.0; }
	    }
    }
}
	'''
	
	@Test
	def void test_Parser(){
		code.parse.assertNoErrors
	}

	@Test
	def void test_Compiler(){
		class.classLoader.setJavaCompilerClassPath
		code.compile[ 
			var o = getCompiledClass.newInstance 
			assertNotNull( o )
			assertTrue( o instanceof CarmaModel )
			val m = o as CarmaModel
			val samplings = 1000
			val dt = 1
			val deadline = samplings*dt
			//var statistics = m.measures.map[  new StatisticSampling<CarmaSystem>(samplings+1, dt,m.getMeasure(it)) ]
			var sim = new SimulationEnvironment( m.getFactory( "Simple" ) )
			//sim.sampling  = new SamplingCollection( statistics )
			sim.sampling = new SamplingFunction<CarmaSystem>() {
				
				override end(double time) {
					print("SIMULATION COMNPLETED")
					println()
				}
				
				override getSimulationTimeSeries( int iterations ) {
					return null;
				}
				
				override sample(double time, CarmaSystem context) {
					var data = context.retrieve( 
						new CarmaPredicate() {
							
							override satisfy(double now,CarmaStore store) {
//								(store.get("payoffs",typeof(Object)) != null)
//								&&
//								(store.get("stable",typeof(Integer))==1)
								(store.get("payoffs",typeof(Object)) != null)
								&&	
								((store.get("step",typeof(Integer))==5)||									
								 ((store.get("step",typeof(Integer))==2))
								)
							}
						
						} , 
						newArrayList( "step" , "powers" , "newpowers" , "payoffs" , "newpayoffs" , "stable") //
					)
					if (data.size > 0) {						
						print(time+" -> \n"+data.map[ it.entrySet.map[ it.toString ].join("\n") ].join("\n\n"))
						println()
						println()
						println()
						println()
						println()					
					}
				}
				
				override start() {
					print("SIMULATION STARTED")
					System.out.println( )
				}
				
			}
			sim.simulate(deadline)
//			var data = sim.timeSeries
//			data.forEach[ it.printTimeSeries(System.out) ] 
		]
	}
	
}