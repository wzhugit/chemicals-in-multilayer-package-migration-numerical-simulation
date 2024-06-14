function C=dmigfinitecnum(cin,Dp,Dc,l1,l2,Kcp,VF,hm,Kpf,Th,M,nt,Ar)
l=l1+l2;
h=l/M;
m=floor(M*l1/l);
T=Th*3600;tao=T/nt;
r1=2*Dp*tao/h/h;r2=2*Dc*tao/h/h;
%Matrix Definition
L=zeros(M+3,M+3);R=zeros(M+3,M+3);
for i=2:1:m
   L(i,i)=5/6+r1/2;L(i,i-1)=1/12-r1/4;L(i,i+1)=1/12-r1/4;
   R(i,i)=5/6-r1/2;R(i,i-1)=1/12+r1/4;R(i,i+1)=1/12+r1/4;
end
L(1,1)=5/12+r1/4;L(1,2)=1/12-r1/4;R(1,1)=5/12-r1/4;R(1,2)=1/12+r1/4;
L(m+1,m)=1/12/tao-Dp/h/h;L(m+1,m+1)=5/12/tao+Dp/h/h;L(m+1,m+2)=5/12/tao+Dc/h/h;L(m+1,m+3)=1/12/tao-Dc/h/h;
R(m+1,m)=1/12/tao+Dp/h/h;R(m+1,m+1)=5/12/tao-Dp/h/h;R(m+1,m+2)=5/12/tao-Dc/h/h;R(m+1,m+3)=1/12/tao+Dc/h/h;

for i=m+2+1:1:M+1
   L(i,i)=5/6+r2/2;L(i,i-1)=1/12-r2/4;L(i,i+1)=1/12-r2/4;
   R(i,i)=5/6-r2/2;R(i,i-1)=1/12+r2/4;R(i,i+1)=1/12+r2/4;
end
L(m+2,m+1)=Kcp;L(m+2,m+2)=-1;
L(M+1+1,M+1)=1/12-r2/2;L(M+1+1,M+1+1)=5/12+hm*tao/h+r2/2;L(M+1+1,M+1+1+1)=-hm*tao/h*Kpf;
R(M+1+1,M+1)=1/12+r2/2;R(M+1+1,M+1+1)=5/12-hm*tao/h-r2/2;R(M+1+1,M+1+1+1)=hm*tao/h*Kpf;
for i=2:1:M+1
    L(M+3,i)=0.5*Ar*h;
    R(M+3,i)=-0.5*Ar*h;
end
L(M+1+1+1,1)=0.25*Ar*h;L(M+1+1+1,m+1)=0.25*Ar*h;L(M+1+1+1,m+2)=0.25*Ar*h;L(M+1+1+1,M+2)=0.25*Ar*h;L(M+1+1+1,M+1+1+1)=0.5*VF;
R(M+1+1+1,1)=-0.25*Ar*h;R(M+1+1+1,m+1)=-0.25*Ar*h;R(M+1+1+1,m+2)=-0.25*Ar*h;R(M+1+1+1,M+2)=-0.25*Ar*h;R(M+1+1+1,M+1+1+1)=-0.5*VF;
%First Iteration
x=zeros(M+3,1);
% MFT=zeros(1,nt);
CinVP=zeros(M+3,1);
CinVP(M+3,1)=cin*Ar*l1;
for i=1:1:m+1
    x(i,1)=cin;
end
for i=m+2:1:M+3
    x(i,1)=0;
end
C=zeros(M+3,nt);
E=L\(R*x+CinVP);
for i=1:1:M+3
    C(i,1)=E(i,1);
end

%Interation
for i=1:1:nt-1
    C(m+2,i)=Kcp*C(m+1,i);
    D=R*C(:,i);
    D1=D+CinVP;
    E=L\D1;
    for j=1:1:M+3
        C(j,i+1)=E(j,1);
    end
    C(m+2,i+1)=Kcp*C(m+1,i+1);
end
C=C(1:end-1,:);
end