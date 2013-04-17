BEGIN {
    P = 100;
}
{
    x = $2;
    i = NR % P;
    MA += (x - Z[i]) / P;
    Z[i] = x;
    print $1, $2, MA;
}