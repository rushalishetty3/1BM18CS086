#include<iostream>
using namespace std;

void toh(char source,char dest,char spare,int n){
    if (n==1)
        cout<<"Move one from "<<source<<" to "<<dest<<endl;
    else{
        toh(source,spare,dest,n-1);
        toh(source,dest,spare,1);
        toh(spare,dest,spare,n-1);
    }
}

int main(){
    int n;
    cout<<"Enter n: ";
    cin>>n;
    toh('a','c','b',n);
    return 0;
}
