import warnings
import random
import argparse as ag
import neurokit2 as nk
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import scipy





def genPespiration(variation,step,frequence,temps):
    array = []
    current_pesp = random.uniform(VOLTAGE_MIN, VOLTAGE_MAX)
    for i in range(0,int(frequence*temps),step):
        delta = random.uniform( -(variation/2.0),variation/2.0)
        for y in range(0,step) :
            current_pesp = current_pesp+ float(delta/step)
            if current_pesp > VOLTAGE_MAX:
                current_pesp = VOLTAGE_MAX
            elif current_pesp < VOLTAGE_MIN:
                current_pesp = VOLTAGE_MIN
            array.append(current_pesp)
    return array

def generateVHDLsamples (array,name):
    y_int = [int(y_i/3.3001 * pow(2,12)) for y_i in array]
    y_hex = ["{0:03X}".format(y_i,2) for y_i in y_int]
    f_vhdl =open("Signal{name}.txt".format(name=name),"w");

    for i in range(len(y_hex)):
        data = "x\"{}\"".format(y_hex[i])
        f_vhdl.write(data)
        f_vhdl.write(",\n")
    f_vhdl.close()

def keepOnlyPositive(array):
    result = []
    for i in array :
        if i < 0 :
            result.append(0)
        else :
            result.append(i)
    return result


VOLTAGE_MAX = 3.3
VOLTAGE_MIN = 0
MAX_SYSTOLIQUE = 140
MAX_DIASTOLIQUE = 90
warnings.filterwarnings('ignore')

plt.rcParams['figure.figsize'] = [10, 6]  # Bigger images

parser= ag.ArgumentParser("Script de génération des échantillons VHDL qui simulent différent type de signaux corporels \n "
                          "Le script peut générer : Pression artérielle, Pouls, respiration,perspiration \n"
                          "Les valeurs par défault pour les signaux à générer sont : \n "
                          "Pouls :  70 bpm , Pression : 120/80, respiration : 0.25Hz (1 respiraiton au 4 seconde , pespiration : 1 (taux de variation entre chaque echantillon)")

parser.add_argument("T",type = str,help = "Le type du signal a généré : les choix sont : pr ,po, re,pe \n pr = Pression, \n po = Pouls, \n re = respiration, \n pe= pespiration")
parser.add_argument( "-t", type = float , default = 1, help = "La durée en seconde du signal généré")
parser.add_argument("-f" ,default = 100 ,type =int, help = "La fréquence d'échantillonage des modules DAC/ADC")
parser.add_argument( "-b" ,type =int, default = 70, help = "le nombre de battement par minutes\n")
parser.add_argument("-r",  type=float, default = 0.25,help="la fréquence en hz de la respiration \n")
parser.add_argument("-D",  type=int, default = 80 ,help="La distolique du patient (deuxieme peak dans le signal de la pression artérielle)  \n")
parser.add_argument("-S",  type=int, default = 120,help="la systolique du patient (premier peak dans le signal de la pression artérielle)  \n")
parser.add_argument("-p",  type=float, default = 1,help="le taux de variation  +/- de la pespiration\n")
parser.add_argument("-s",  type=int, default = 1,help="le nombre d'echantillon identique avant une variation dans le signal de la pespiration\n")
args = parser.parse_args()

signaltype =vars(args)["T"]
t = vars(args)["t"]
f = vars(args)["f"]
bpm = vars(args)["b"]
diastolic = vars(args)["D"]
systolic = vars(args)["S"]
respiration = vars(args)["r"]
pespiration = vars(args)["p"]
step = vars(args)["s"]
print(signaltype,t,f,bpm,diastolic,systolic,respiration,pespiration)
ech_array = []

if "po" in signaltype:
    #procedure pour generer un pouls
    samples_pouls =  nk.ecg_simulate(duration=t, sampling_rate=f ,noise=.05, heart_rate=bpm,method="simple")
    ech_array = keepOnlyPositive(samples_pouls)
    ech_array /= np.max(ech_array,axis=0)/3.3

elif "pr" in signaltype :

    index = np.linspace(-9, 9, num= int(f / (bpm/60)))
    normal1 = scipy.stats.norm.pdf(index, loc=-2, scale=1)*  (systolic/MAX_SYSTOLIQUE)#premier peak systolique
    normal2 = scipy.stats.norm.pdf(index, loc=2, scale=1.5)* (diastolic/MAX_DIASTOLIQUE) # deuxieme peak diastolique
    samples = 8 * (normal1 + normal2) #facteur 8 seulement pour scaler entre 0 et 3.3

    # La valeur en Voltage d'une personne qui a une systolique normal (120), est autour de  2.8 , pour une systolique eleve(140), on est autour de 3.2 , une sytolique basse (100) est autour de 2.3
    #la valeur en Voltage d'une personne qui a une diastolique normal (80) est autour de 1.8 ,  pour une diastolique eleve(90), on est atour de 2.10, une diastolique basse (60) est autour de  1.4

    #prolongement du signal de pression selon le temps de signal voulu
    for i in range(0,int(t)):
        for y in samples:
            ech_array.append(y)

elif "re" in signaltype:
    t_sin = np.arange(t*f)
    ech_array = 1.65 * np.sin(respiration * (2 * np.pi * t_sin) / f) + 1.65 # le plus 1 est pour ne pas avoir de valeur negative
elif "pe" in signaltype:
    ech_array = genPespiration(pespiration,step,f,t)
else :
    ValueError("The fuck is that signal type ??  give me a valid one , you gave me  {}".format(signaltype))

# # Visualize
ecg = pd.DataFrame({"{}".format(signaltype): ech_array})

nk.signal_plot(ecg)
#
plt.show()

generateVHDLsamples(ech_array,signaltype)




