#include<iostream>
using namespace std;
int a[10][10],top,s[10],vertex,visited[10];

void dfs(int v,int n){
   visited[v]=1;
   for(int i=0;i<n;i++){
      if(a[v][i]){
         s[top++]=i;
         if(!visited[i])
            dfs(i,n);
      }
   }
}

int isCycle(){
   for(int i=0;i<top;i++)
      if(vertex==s[i])
         return 0;
   return 1;
}

int main(){
   int n;
   cout<<"Enter no of vertices: ";
   cin>>n;
   cout<<"Enter adjacency matrix:";
   for(int i=0;i<n;i++)
      for(int j=0;j<n;j++)
         cin>>a[i][j];
   for(int i=0;i<n;i++){
      top=0;
      vertex=i;
      dfs(i,n);
      for(int i=0;i<n;i++)
         visited[i]=0;
      int result=isCycle();
      if(result==0){
         cout<<"Cyclic Graph"<<endl;
         exit(0);
      }
   }
   cout<<"Not Cyclic Graph"<<endl;
}