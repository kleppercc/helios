%------------------------------------------------------------------------
%-
%- tets script to load hdf5 data and build ratios
%-
%-
%------------------------------------------------------------------------

shotnum=115745;

%--- chordal setups
%--- pseudo chan 26 is for damaged tubes in given setup -> set to 0cm
A=[3 5 7 9 11 13 15 17 19 21 23 25];
B=[15 16 17 26 18 19 20 21 22 23 24 25];
C=[4 5 6 26 7 8 9 10 11 12 13 14];
U=B; %--- pick which setup to use

%--- down sampling ferquency
downSampF=250; %--- 115743
%downSampF=200; %--- 115746, 47, 48


%--- GENERAL GEOMETRIC OVERVIEW
%--- generate Zvector with even spacing
fChordVec=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25, 26];
Zstart=41.8;
Zend=45.6;
dz=(Zend-Zstart)/25;
for i=1:25
    zVec(i)=(Zend-(i-1)*dz)/100;
end
%--- sort some channels manually (from in vessel calibration)
tmp=zVec(24);
zVec(24)=zVec(1);
zVec(1)=tmp;
rVec=(zVec./zVec)+0.84;
zVec(26)=0.0;
rVec(26)=0.0;

fid = fopen(['coordinates_HELIOS_', num2str(shotnum), '.txt'],'w');
fprintf(fid,'%6.2f  %6.2f\n',rVec, zVec);
fclose(fid);


%--- plot numbering
figure, plot(zVec, fChordVec, 'o')
set(gca, 'FontSize', 14, 'FontWeight', 'bold')
ylabel('fiber chord number', 'FontSize', 14, 'FontWeight', 'bold')
xlabel('height coordinate Z [cm]', 'FontSize', 14, 'FontWeight', 'bold')
%--- plot equilibirum
[R, a, Rsepout, Rsepin, qa, bp1, altPos, shavShift, Ip2, Bt2, ext]=equi_guess(115745,1.5,0,30,1);
plot(rVec, zVec, 'ko', 'MarkerFaceColor', 'r')
ylim([0.41, 0.46])
xlim([1.82, 1.88])
for i=1:length(fChordVec)
    text(1.845, zVec(i), num2str(fChordVec(i)), 'FontSize', 8, 'FontWeight', 'bold');
end


%--- SORT CHORDS To TUBES
pmtSigno=zeros(3, 12);
%--- ordering needed -> 728, 706, 668 channel
%--- challen ordering is messy in hdf5 files, cleaned up manually here
pmtSigno(:,1)=[ 2 4 6 ];
pmtSigno(:,2)=[10 12 14];
pmtSigno(:,3)=[18 20 22];
pmtSigno(:,4)=[32 30 38];
pmtSigno(:,5)=[40 38 36];
pmtSigno(:,6)=[48 46 44];
pmtSigno(:,7)=[50 52 54];
pmtSigno(:,8)=[58 60 62];
pmtSigno(:,9)=[66 68 70];
pmtSigno(:,10)=[80 78 76];
pmtSigno(:,11)=[88 86 84];
pmtSigno(:,12)=[96 94 92];

%--- generate time axis (assume same time axis for all chanels)
tt.info=hdf5info(['~/Dropbox/Helios data/HELIOS_', num2str(shotnum), '.h5']);
tt.dt=hdf5read(tt.info.GroupHierarchy.Filename, tt.info.GroupHierarchy.Groups(2).Datasets(1).Name);
tt.delay=hdf5read(tt.info.GroupHierarchy.Filename, tt.info.GroupHierarchy.Groups(2).Datasets(5).Name);
tt.noSamp=hdf5read(tt.info.GroupHierarchy.Filename, tt.info.GroupHierarchy.Groups(2).Datasets(4).Name);
tt.t0=hdf5read(tt.info.GroupHierarchy.Filename, tt.info.GroupHierarchy.Groups(2).Datasets(6).Name);
%--- generate downsampled time base (250Hz)
fact=(1/downSampF)/tt.dt;
addDelay=-0.04;
tt.timeBase=(tt.t0+tt.delay+addDelay)+linspace(0, double(tt.noSamp)/fact*(tt.dt*fact), double(tt.noSamp)/fact); 

%--- get SHE time data for HE pulses
%--- cut data inside of SHE pulses
%--- load SHE time base
sheT=twuget(shotnum, 'jdaq/SHE/SHE1');
sheT.interp=interp1(sheT.x0, sheT.y, tt.timeBase);
%--- get indicess during SHE on time
I=find(sheT.interp>0.0);

%--- setup arrays
tmp728=hdf5read(tt.info.GroupHierarchy.Filename, tt.info.GroupHierarchy.Groups(1).Datasets(2).Name);
tmp706=hdf5read(tt.info.GroupHierarchy.Filename, tt.info.GroupHierarchy.Groups(1).Datasets(4).Name);
tmp668=hdf5read(tt.info.GroupHierarchy.Filename, tt.info.GroupHierarchy.Groups(1).Datasets(6).Name);
tt.data668=zeros(12, length(tmp668));
tt.data668=zeros(12, length(tmp668));
tt.data668=zeros(12, length(tmp668));

%--- prepare data
for k=1:12
    tmp728=hdf5read(tt.info.GroupHierarchy.Filename, tt.info.GroupHierarchy.Groups(1).Datasets(pmtSigno(1,k)).Name);
    tmp706=hdf5read(tt.info.GroupHierarchy.Filename, tt.info.GroupHierarchy.Groups(1).Datasets(pmtSigno(2,k)).Name);
    tmp668=hdf5read(tt.info.GroupHierarchy.Filename, tt.info.GroupHierarchy.Groups(1).Datasets(pmtSigno(3,k)).Name);
    %--- cut data
    tmp_cut668=zeros(length(tt.timeBase),1);
    tmp_cut668(I)=tmp668(I);
    tmp_cut706=zeros(length(tt.timeBase),1);
    tmp_cut706(I)=tmp706(I);
    tmp_cut728=zeros(length(tt.timeBase),1);
    tmp_cut728(I)=tmp728(I);
    %--- put data into array
    tt.data668(k, :)=tmp_cut668;
    tt.data706(k, :)=tmp_cut706;
    tt.data728(k, :)=tmp_cut728;
end

figure, 
set(gcf, 'Position', [17    90   921   426])
subplot(1,3,1)
pcolor(tt.timeBase, zVec(U),  tt.data668)
shading interp
tc=colormap;
tc(1,:)=0;
colormap(tc)
set(gca, 'FontSize', 14, 'FontWeight', 'bold')
ylabel('height coordinate Z [m]', 'FontSize', 14, 'FontWeight', 'bold')
xlabel('time t [s]', 'FontSize', 14, 'FontWeight', 'bold')
ylim([0.43, 0.452])
subplot(1,3,2)
pcolor(tt.timeBase, zVec(U),  tt.data706)
shading interp
tc(1,:)=0;
colormap(tc)
set(gca, 'FontSize', 14, 'FontWeight', 'bold')
xlabel('time t [s]', 'FontSize', 14, 'FontWeight', 'bold')
ylim([0.43, 0.452])
subplot(1,3,3)
pcolor(tt.timeBase, zVec(U),  tt.data728)
shading interp
tc(1,:)=0;
colormap(tc)
set(gca, 'FontSize', 14, 'FontWeight', 'bold')
xlabel('time t [s]', 'FontSize', 14, 'FontWeight', 'bold')
ylim([0.43, 0.452])


%--- build test ratios
tt.rTe=zeros(12, length(tt.timeBase));
tt.rne=zeros(12, length(tt.timeBase));
tt.rTe(:, I)=tt.data728(:, I)./tt.data706(:, I);
tt.rne(:, I)=tt.data668(:, I)./tt.data728(:, I);

%--- load CRM setup
[ne_axis, Te_axis, ne_ratio_model, Te_ratio_model]=load_tapete('tapete_all_n_62_a.mat');
%*** Define boundaries for ne and te values
%   Shotnumber  Te_min  Te_Max  ne_Min      ne_Max
BoundVal=[   115000       5       500     1.0*10^18   6.0*10^19];
%--- look up data
[tt.ne_He, tt.Te_He]=lookup_neTe(ne_axis, Te_axis, ne_ratio_model, Te_ratio_model, tt.rne, tt.rTe, BoundVal);




% 
% 
% figure,
% hold on
% set(gcf, 'Position', [120   658   560   420])
% plot(tt.timeBase, tt.cut668*1.0e-15)
% plot(tt.timeBase, tt.cut706*1.0e-15, 'r')
% plot(tt.timeBase, tt.cut728*1.0e-15, 'g')
% set(gca, 'FontSize', 14, 'FontWeight', 'bold')
% ylabel('emission [10^{15} photons s^{-1}]', 'FontSize', 14, 'FontWeight', 'bold')
% xlabel('time t [s]', 'FontSize', 14, 'FontWeight', 'bold')
% xlim([0,7])
% legend('\lambda_1=667.8nm', '\lambda_1=706.5nm', '\lambda_1=728.4nm')
% 
% figure, 
% subplot(2,1,1)
% plot(tt.timeBase, tt.rTe)
% ylim([-0.2, 1.5])
% set(gca, 'FontSize', 14, 'FontWeight', 'bold')
% xlim([0,7])
% ylabel('r_{Te}', 'FontSize', 14, 'FontWeight', 'bold')
% subplot(2,1,2)
% plot(tt.timeBase, tt.rne)
% ylim([-0.2, 7])
% ylabel('r_{ne}', 'FontSize', 14, 'FontWeight', 'bold')
% xlabel('time t [s]', 'FontSize', 14, 'FontWeight', 'bold')
% set(gca, 'FontSize', 14, 'FontWeight', 'bold')
% xlim([0,7])
% 
% figure, 
% set(gcf, 'Position', [1241         657         560         420])
% subplot(2,1,1)
% plot(tt.timeBase, tt.Te_He)
% ylim([0, 100])
% set(gca, 'FontSize', 14, 'FontWeight', 'bold')
% xlim([0,7])
% ylabel('T_e [eV]', 'FontSize', 14, 'FontWeight', 'bold')
% subplot(2,1,2)
% plot(tt.timeBase, tt.ne_He*1.0e-19)
% ylim([0, 1.0])
% ylabel('n_e [10^{19} m^{-3}]', 'FontSize', 14, 'FontWeight', 'bold')
% xlabel('time t [s]', 'FontSize', 14, 'FontWeight', 'bold')
% set(gca, 'FontSize', 14, 'FontWeight', 'bold')
% xlim([0,7])