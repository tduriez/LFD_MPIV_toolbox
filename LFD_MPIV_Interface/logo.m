function logo(the_axis)

axes(the_axis);

%% Tunnel
p(1)=plot3([0 2 2 0 0],[0 0 0 0 0],[0 0 1 1 0]);hold on
p(2)=plot3([0 2 2 0 0],[10 10 10 10 10],[0 0 1 1 0]);
p(3)=plot3([0 0 0 0 0],[0 10 10 0 0],[0 0 1  1 0]);
p(4)=plot3([2 2 2 2 2],[0 10 10 0 0],[0 0 1  1 0]);hold off
for i=1:4
    set(p(i),'linewidth',1.2,'color','k')
end
comp=2;
view(30,15);daspect([1 1 comp])

%% Spheres
n_spheres=200;
size_sphere=0.05;
[X,Y,Z] = sphere(20);
ix=rand(1,n_spheres)*(2-2*size_sphere)+size_sphere;
iz=rand(1,n_spheres)*(10-2*size_sphere)+size_sphere;
iy=rand(1,n_spheres)*(1-2*size_sphere)+size_sphere;
size_sphere=0.1;

shading interp
hold on
for i=1:n_spheres
    sp(i)=mesh(X*size_sphere+ix(i),Y*size_sphere+iz(i),Z*size_sphere*comp+iy(i),(X*size_sphere+ix(i)).*(X*size_sphere+ix(i)-2).*(Z*size_sphere*comp+iy(i)).*(Z*size_sphere*comp+iy(i)-1));
    set(sp(i),'FaceColor',[0 0 0])
    set(sp(i),'EdgeColor','none')
end
hold off

camlight
lighting phong

%% Vector fields
[x,z,y]=meshgrid(0:0.01:2,0:0.01:10,0:0.01:1);
u=(x.*(x-2)).*(y.*(y-1));
hold on
s=slice(x,z,y,u,1,10,[]);
for i=[1 2]
    set(s(i),'faceAlpha','interp','alphaData',2-(get(s(i),'YData'))/20+0.5)
end

hold off
shading interp

set(gca,'visible','off')

%% Animating
k=-10:+1:0;
%length(sp)
hold on
p=surf(permute(x(1,:,:),[2 3 1]),permute(u(1,:,:)*5,[2 3 1]),permute(y(1,:,:),[2 3 1]));
set(p,'facealpha',0.5,'edgecolor','none')
hold off
for l=1:length(k)
    i=k(l);
    for j=1:n_spheres
        set(sp(j),'FaceAlpha',max(0,min(1,iz(j)/10-i/10-1)))
    end
    if l>1
    set(p,'YData',get(p,'YData')+1);
    end
    set(gca,'alim',[1.5 2]-i/10)
    G(l)=getframe(gca);
end
% 
% 
 



