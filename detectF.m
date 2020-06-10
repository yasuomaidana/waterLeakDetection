%Algoritmo de detección de fuga
function [fuga,info]=detectF(datos,datostrained,id)
    info='';
    MaxFT4Design = Training(datostrained.y);%Resultado de la rutina de prediccion, se utilizara para los datos reales posteriores

    h=0; %cantidad de ceros consecutivos
    j=0; %minutos de agua continua
    k=0; %gasto total
    a=[];%matriz j
    b=[]; %matriz k
    fuga=false;
    datos=fil(datos);
    datos=datos(:,2);
    datos=datos*1000;
    %Algoritmo de detección de fuga

    for i=1:size(datos)
        if datos(i)<0.001 %Minimo sensibilidad sensor
            if h==5
                if j>5
                    a(i)=j-5;
                else
                    a(i)=j;
                end
                if j==0
                    b(i)=0; 
                else
                    b(i)=k/j;
                end
                j=0;
                k=0;
            else
                h=h+1;
                j=j+1;
                a(i)=j;
                if i>2
                    b(i)=b(i-1);
                else
                    b(i)=0;
                end
                k=k+datos(i);
            end
        else
            h=0;
            j=j+1;
            a(i)=j;
            b(i)=k/j;
            k=k+datos(i);

            datostrained=id;
            datostrained=datostrained.y;

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ((a(i)>MaxFT4Design) && (b(i)<1)) || (a(i)>MaxFT4Design*2)
            if(fuga==false)
                %disp("Se detectó NUEVA fuga en la hora:")
                Hora=floor(mod(i,1440)/60);
                Minuto=floor((mod(mod(i,1440),60)));
                tiempo=[num2str(Hora),':',num2str(Minuto)];
                info=tiempo;
                %disp(tiempo)
                %disp("     Tiempo continuo:")
                %disp(a(i))
                %disp("     Promedio:")
                %disp(b(i))
                fuga=~fuga;
            end
        else
            if(fuga==true)
                %disp("No se detecta fuga en el min:")
                Hora=floor(mod(i,1440)/60);
                Minuto=floor((mod(mod(i,1440),60)));
                %tiempo=['Hora: ',num2str(Hora),':',num2str(Minuto)];
                %disp(tiempo)
                %disp("Posible consumo anormal de agua")
                fuga=~fuga; %Variable de salida
            end
        end  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    end
    
    %shw(datos,a,b)
end
function shw(datos,a,b)
    figure('Name','Resultados')
    subplot(3,1,1);plot(datos);
    xlabel('Tiempo (seg)')
    ylabel('Consumo')
    grid on

    subplot(3,1,2);plot(a);
    xlabel('Tiempo (seg)')
    ylabel('Tiempo Activo')
    grid on

    subplot(3,1,3);plot(b);
    xlabel('Tiempo (seg)')
    ylabel('Media tiempo activo')
    grid on
end
function ret=fil(datos)
        ret=0;
        min=datos.Time;
        dat=datos.Data;
        ind=1;
        for i=1:size(min,1)
            if mod(min(i),1)==0
                ret(ind,1)=min(i);
                ret(ind,2)=dat(i);
                ind=ind+1;
            end
        end
end
function MaxFT4Design = Training(datos)

        datos1=datos;

        h=0; %cantidad de ceros consecutivos
        j=0; %minutos de agua continua
        k=0; %gasto total
        a=[];%matriz j
        b=[]; %matriz k
        for i=1:size(datos1)
            if datos(i)<0.001 %Minimo sensibilidad sensor
                if h==5
                    if j>5
                        a(i)=j-5;
                    else
                        a(i)=j;
                    end
                    if j==0
                        b(i)=0; 
                    else
                        b(i)=k/j;
                    end
                    j=0;
                    k=0;
                else
                    h=h+1;
                    j=j+1;
                    a(i)=j;
                    if i>2
                        b(i)=b(i-1);
                    else
                        b(i)=0;
                    end
                    k=k+datos1(i);
                end
            else
                h=0;
                j=j+1;
                a(i)=j;
                b(i)=k/j;
                k=k+datos1(i);

            end
        end

        MaxFT4Design = max(a);

    end