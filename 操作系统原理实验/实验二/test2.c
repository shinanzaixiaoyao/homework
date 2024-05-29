// 哲学家就餐问题
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

#define M 5

sem_t sfork[5];

void *philosopher(void *p)
{
    // 方案一
    int id = (int)p;
    printf("\nNO%d Thinking ……", id);

    if (id % 2 == 0)
    {
        sem_wait(&sfork[id]);
        sem_wait(&sfork[(id + 1) % 5]);
    }
    else
    {
        sem_wait(&sfork[(id + 1) % 5]);
        sem_wait(&sfork[id]);
    }

    printf("\nNO%d Eating……", id);

    sem_post(&sfork[id]);
    sem_post(&sfork[(id + 1) % 5]);

    return NULL;
}

int main(void)
{
    int i;

    for (i = 0; i < 5; i++)
    {
        sem_init(&sfork[i], 0, 1);
    }

    pthread_t tid[5];

    for (i = 0; i < 5; i++)
    {
        pthread_create(&tid[i], NULL, philosopher, (void *)i);
    }

    for (i = 0; i < 5; i++)
    {
        pthread_join(tid[i], NULL);
    }

    for (i = 0; i < M; i++)
    {
        sem_destroy(&sfork[i]);
    }
}