# GPON-FTTH-Performance-Analysis
MATLAB-based performance analysis of GPON over FTTH considering fiber loss, split ratio, and BER.

# GPON FTTH Performance Analysis using MATLAB

This project simulates the performance of a GPON (Gigabit Passive Optical Network) over Fiber-To-The-Home (FTTH) using MATLAB. It analyzes the effect of varying fiber lengths and split ratios on the received power and Bit Error Rate (BER) at the Optical Network Terminal (ONT).

## 🔧 Features

- Calculates power loss due to fiber attenuation and passive splitter
- Models SNR and BER variations with increasing fiber length
- Plots:
  - Received Power vs. Fiber Length
  - BER vs. Fiber Length (semilog scale)


###  Why BER Increases with Fiber Length:

1. Higher Fiber Length ⇒ More Attenuation:

   * Each kilometer of single-mode fiber adds \~0.35 dB loss (in your model).
   * This causes a drop in **received optical power.

2. Lower Received Power ⇒ Lower SNR:

   * You're calculating SNR as:

     ```
     snr_db = received_power - receiver_sensitivity
     ```
   * So, as received power drops, SNR drops.

3. Lower SNR ⇒ Higher BER:

   * BER (Bit Error Rate) increases exponentially as SNR decreases.
   * That’s modeled here by:

     ```matlab
     ber = 0.5 * erfc(sqrt(10.^(snr_db/10)))
     ```

4. At Very Low SNR ⇒ BER → 1:

   * When received power is much lower than receiver sensitivity (e.g., < –28 dBm), the SNR becomes very poor, leading BER to approach 1.
   * BER = 1 means almost all bits are received incorrectly — effectively no usable communication.

---

### What This Tells You:

* Your **BER vs. Fiber Length plot** is a performance indicator.
* It helps you determine the max fiber length and split ratio for reliable service under certain conditions.
* Example: For split = 64, you might find BER acceptable only up to 10 km.

