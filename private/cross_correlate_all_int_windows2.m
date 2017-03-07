function c=cross_correlate_all_int_windows2(A,B,N)
A=single(A);B=single(B);
fftA=fft2(A);
fftB=fft2(B);
c=fftshift(fftshift(real(ifft(ifft(conj(fftA).*fftB,N,2),N,1)),2),1);
c(c<0)=0;
end


