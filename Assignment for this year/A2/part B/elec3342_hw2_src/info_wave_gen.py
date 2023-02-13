'''
  Generate multipule sine waves (txt) including a sentence for a VHDL test bench.
  Author: Jiajun Wu, CASR, HKU.
  Spec:
	- sample rate 96kHz
'''

import math
import argparse


def cal_sample_num(adc_rate, symbol_rate, head_tail=False):
    if head_tail == True:
        # need to keep for the head 4 symbols and tail 4 symbols
        samples_num = int(adc_rate*5/symbol_rate)
    else:
        samples_num = int(adc_rate/symbol_rate)
    return samples_num


# args = docopt(__doc__)
parser = argparse.ArgumentParser(description='testbench_config')
parser.add_argument(
    '--adc_bw', '-b', help='ADC bit width (default 12-bit)', default=12)
parser.add_argument(
    '--adc_freq', '-f', help='ADC sampling frequency (rate), default 96000', default=96000)
parser.add_argument(
    '--sym_rate', '-r', help='Symbol rate of decoder (default 16)', default=16)
parser.add_argument(
    '--info_str', '-s', help='Information which needs to be decoded (default ELEC)', default="ELEC")
args = parser.parse_args()

dic_table = {'A': ['1', '2'], 'B': ['1', '3'], 'C': ['1', '4'], 'D': ['1', '5'], 'E': ['1', '6'],
             'F': ['2', '1'], 'G': ['2', '3'], 'H': ['2', '4'], 'I': ['2', '5'], 'J': ['2', '6'],
             'K': ['3', '1'], 'L': ['3', '2'], 'M': ['3', '4'], 'N': ['3', '5'], 'O': ['3', '6'],
             'P': ['4', '1'], 'Q': ['4', '2'], 'R': ['4', '3'], 'S': ['4', '5'], 'T': ['4', '6'],
             'U': ['5', '1'], 'V': ['5', '2'], 'W': ['5', '3'], 'X': ['5', '4'], 'Y': ['5', '6'],
             'Z': ['6', '1'], '!': ['6', '2'], '.': ['6', '3'], '?': ['6', '4'], ' ': ['6', '5']
             }

# frequency (Hz)
freq_table = {'0': 523, '1': 659, '2': 784, '3': 988,
              '4': 1175, '5': 1397, '6': 1760, '7': 2093}

symbol_rate = args.sym_rate
adc_samp_rate = int(args.adc_freq)
print(adc_samp_rate)
wave_bits = args.adc_bw
code_str = args.info_str
wave_amp = 2 ** (wave_bits - 1) - 1

print('-- Coding infomation into a symbol sequence')
print(code_str)
symbol_seq = ['0', '7', '0', '7']
for i in range(len(code_str)):
    symbol_seq = symbol_seq + dic_table.get(code_str[i])
symbol_seq = symbol_seq + ['7', '0', '7', '0']
print(symbol_seq)

print('-- Sine wave table generation')
sine_wave_list = []
total_samp_num = 0
for index in range(len(symbol_seq)):
    # head_tail = (index == 0) or (index == len(symbol_seq) - 1)
    wave_freq = freq_table.get(symbol_seq[index])
    samples_num = cal_sample_num(adc_samp_rate, symbol_rate, False)
    for samp in range(samples_num):
        new_sample = int(wave_amp * math.sin(2 * math.pi *
                                             wave_freq * samp / adc_samp_rate))
        bin_sample = (bin(((1 << 12) - 1) & new_sample)[2:]).zfill(12)
        sine_wave_list.append(bin_sample)
    total_samp_num += samples_num
print(total_samp_num)

print('-- Writing txt file')
with open("info_wave.txt", "w") as f:
    amp_index = 0
    for samp_amp in sine_wave_list:
        if amp_index < (total_samp_num - 1):
            f.write(samp_amp + '\n')
        else:
            f.write(samp_amp)
        amp_index += 1
