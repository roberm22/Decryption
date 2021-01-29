%% P2: Demodulación de una señal DTMF mediante la STFT

% Autor: Roberto Martín

%Limpiamos
clc
clear


%% TELEFONO

flag = 1;
  
while flag < 3

    if (flag == 1)
        load telef1.mat;
    else
        load telef2.mat;
    end 
    
    signal=telef;

    % Ventana, especificada como un entero o como un vector de fila o columna. 
    % Se utiliza para dividir la señal en segmentos:window. Si es un entero (como es en nuestro caso), 
    % se divide en segmentos de longitud y ventanas de cada segmento con una ventana Hamming de esa longitud
    % La ventana la calculamos a partir de [ periodo * frecuencia de muestreo(fs)]. 
    % Transparencias Tema 4 DFT, página 15 ejemplo.

    % Conviene mencionar también que la modulación consiste en símbolos (dígitos) separados por
    % silencios, siendo la duración de cada dígito 180 mseg. y la de cada silencio 90 mseg.

    window=765;

    % Hacemos lo mismo que para P1

    nfft=3*window;
    noverlap=0;

    % Sacamos por pantalla el espectrograma

    figure(flag)
    spectrogram(signal,window,noverlap,nfft,fs);


    % Vector de frecuencias de las cuatro primeras

    bin1=round(nfft*704/fs);
    bin2=round(nfft*792/fs);
    bin3=round(nfft*872/fs);
    bin4=round(nfft*956/fs);

    [S,F,T]=spectrogram(signal,window,noverlap,nfft,fs);

    S_4primeras = S([bin1,bin2,bin3,bin4],:);
    
    % Vector de frecuencias de las tres ultimas

    bin5=round(nfft*1224/fs);
    bin6=round(nfft*1368/fs);
    bin7=round(nfft*1512/fs);
    
    S_3ultimas = S([bin5,bin6,bin7],:);
    
    % Hacemos lo mismo que hemos hecho en P1 (mismo procedimiento)

    S1abs = abs(S_4primeras);
    S2abs = abs(S_3ultimas);
    [M1,I1] = max(S1abs);
    [M2,I2] = max(S2abs);


    % Escogemos de las 2 posibles ventanas para cada símbolo, la segunda ventana 
    % ya que es la mas importante y quitamos los silencios.
    % Enseñar la señal en examen oral para explicarlo

    n1=[I1(2),I1(5),I1(8),I1(11),I1(14),I1(17),I1(20),I1(23),I1(26)];
    n2=[I2(2),I2(5),I2(8),I2(11),I2(14),I2(17),I2(20),I2(23),I2(26)];


    % Ahora creamos con strings un "Square Array of Empty Strings" de 1x1 que
    % servirá para almacenar el numero en el que nos encontramos en el bucle:

    numero = strings(1);

    % Bucle que recorre todas las posibles combinaciones de parejas y lo añade
    % al numero de telefono final, con 9 simbolos.

    for i = 1:length(n1)

        teclado = ['1' '2' '3'; '4' '5' '6'; '7' '8' '9'; '#' '0' '*']; 
        numero = numero + teclado(n1(i), n2(i));

    end

    fprintf('NUMERO TELEFONO %d:\n\n\t<strong>%s</strong> \n\n', flag, numero);
    
    flag = flag + 1;
end
