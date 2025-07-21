%% GPON FTTH Performance Analysis using MATLAB
% Author: Aryan Mohan Saxena
% Description:
% This script simulates the performance of a GPON (Gigabit Passive Optical Network)
% by evaluating how fiber length and split ratios affect received optical power
% and Bit Error Rate (BER) at the Optical Network Terminal (ONT).

clc; clear; close all;

%% System Parameters
P_tx = 5;                         % Transmit power (dBm), typical for OLT
attenuation_db_per_km = 0.35;    % SMF attenuation coefficient (dB/km)
receiver_sensitivity = -28;      % ONT receiver sensitivity threshold (dBm)

fiber_length_km = [5 10 15 20 25];          % Fiber lengths to simulate (km)
split_ratios = [8 16 32 64];               % Users per OLT port

% BER as a function of SNR (dB)
snr_to_ber = @(snr_db) 0.5 * erfc(sqrt(10.^(snr_db/10)));

%% Simulation Loop
for i = 1:length(split_ratios)
    split = split_ratios(i);
    split_loss_db = 10 * log10(split);   % Loss due to passive optical splitter (dB)

    received_power = zeros(1, length(fiber_length_km)); % In dBm
    snr_db = zeros(1, length(fiber_length_km));         % Signal-to-noise ratio
    ber = zeros(1, length(fiber_length_km));            % Bit Error Rate

    for j = 1:length(fiber_length_km)
        fiber_length = fiber_length_km(j);
        fiber_loss_db = fiber_length * attenuation_db_per_km;
        total_loss_db = fiber_loss_db + split_loss_db;

        % Compute received power
        received_power(j) = P_tx - total_loss_db;

        % SNR calculation (simplified model)
        snr_db(j) = received_power(j) - receiver_sensitivity;

        % Compute BER
        ber(j) = snr_to_ber(snr_db(j));
    end

    %% Plot: Received Power vs Fiber Length
    figure(1);
    plot(fiber_length_km, received_power, '-o', ...
        'DisplayName', sprintf('Split %d', split));
    hold on;
    xlabel('Fiber Length (km)');
    ylabel('Received Power (dBm)');
    title('Received Power vs Fiber Length');
    grid on;
    legend show;

    %% Plot: BER vs Fiber Length
    figure(2);
    semilogy(fiber_length_km, ber, '-o', ...
        'DisplayName', sprintf('Split %d', split));
    hold on;
    xlabel('Fiber Length (km)');
    ylabel('Bit Error Rate (BER)');
    title('BER vs Fiber Length');
    grid on;
    legend show;
end

%% Notes:
% - Received power is expressed in dBm, and negative values are normal in optical
%   communication due to attenuation and passive losses.
% - BER increases with fiber length and higher split ratios due to reduced received
%   power and lower signal-to-noise ratio.
% - Once received power drops below receiver sensitivity (~-28 dBm), BER approaches 1,
%   indicating nearly all bits may be received incorrectly.
