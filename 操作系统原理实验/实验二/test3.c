// 读者-写者问题
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

#define M 10

sem_t sdata, srcount;
int readcount = 0;

void *reader(void *p)
{
    sem_wait(&srcount);
    readcount++;
    if (readcount == 1)
    {
        sem_wait(&sdata);
    }
    sem_post(&srcount);
    printf("\nNO%d reader reading dataset ……", readcount);

    sem_wait(&srcount);
    readcount--;
    if (readcount == 0)
    {
        sem_post(&sdata);
    }
    sem_post(&srcount);
    return NULL;
}

void *writer(void *p)
{
    sem_wait(&sdata);
    printf("\nWriter writing dataset……");
    sem_post(&sdata);
    return NULL;
}

int main(void)
{
    sem_init(&sdata, 0, 1);
    sem_init(&srcount, 0, 1);
    pthread_t tid[M], tid2[M];
    int i;

    for (i = 0; i < M; i++)
    {
        pthread_create(&tid[i], NULL, writer, NULL);
    }
    for (i = 0; i < M; i++)
    {
        pthread_create(&tid2[i], NULL, reader, NULL);
    }

    for (i = 0; i < M; i++)
    {
        pthread_join(tid[i], NULL);
    }
    for (i = 0; i < M; i++)
    {
        pthread_join(tid2[i], NULL);
    }

    sem_destroy(&srcount);
    sem_destroy(&sdata);
}