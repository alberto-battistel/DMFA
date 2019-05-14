function y = RectVarf(fr,fc,bw,n)
    X = (fr-fc)/bw;
    y = ((1+exp(-n)).^2)./((1+exp(-n*(X+1))).*(1+exp(n*(X-1))));
    % For n larger or equal to Ns/bw, the shape is almost perfectly
    % rectangular. There is no real higher limit. The lower is n, the more
    % confined is the spreading of the skirt in the time domain. n equal to
    % 4 is suggested to have a quite confined skirt, keeping the
    % rectangular shape at the center.
end