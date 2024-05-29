/*
使用信号量：代码使用了信号量来实现哲学家之间的同步和互斥操作。
sfork信号量数组来表示每个叉子的可用状态，
waiter信号量来限制同时就餐的哲学家数量，
eatCountMutex互斥锁来保护eatCount计数器的操作。

保证每个哲学家只就餐一次：通过增加一个全局的eatCount变量，并在每个哲学家完成就餐时对其进行增加，可以确保每个哲学家只就餐一次。
此外，使用互斥锁eatCountMutex来保护对eatCount的操作，以确保线程安全。

输出就餐完成信息并退出：在所有哲学家都就餐完毕后，通过检查eatCount是否等于哲学家的数量N，输出相应的信息并退出程序。

引入随机延迟：为了增加系统的随机性，引入了随机延迟，使得每个哲学家的行为更加独立和多样化。

使用线程和互斥锁：代码使用了pthread库来创建和管理哲学家的线程，并使用互斥锁来保护共享资源的访问，以避免数据竞争和不一致性。
*/

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

#define N 5

sem_t sfork[N];
sem_t waiter;
sem_t eatCountMutex;
int eatCount = 0;

void *philosopher(void *p)
{
    int id = (int)p;
    printf("\nPhilosopher %d Thinking...\n", id);

    while (1)
    {
        // 等待服务员
        sem_wait(&waiter);

        // 获取左手边的叉子
        sem_wait(&sfork[id]);
        printf("\nPhilosopher %d Picked up left fork", id);

        // 获取右手边的叉子
        sem_wait(&sfork[(id + 1) % N]);
        printf("\nPhilosopher %d Picked up right fork", id);

        printf("\nPhilosopher %d Eating...", id);

        // 放下左手边的叉子
        sem_post(&sfork[id]);
        printf("\nPhilosopher %d Put down left fork", id);

        // 放下右手边的叉子
        sem_post(&sfork[(id + 1) % N]);
        printf("\nPhilosopher %d Put down right fork", id);

        // 通知服务员
        sem_post(&waiter);

        // 增加就餐计数
        sem_wait(&eatCountMutex);
        eatCount++;
        sem_post(&eatCountMutex);

        // 检查是否所有哲学家都已就餐完毕
        if (eatCount == N)
        {
            printf("\nAll philosophers have finished dining.\n");
            exit(0);
        }

        printf("\nPhilosopher %d Thinking...\n", id);

        // 增加随机延迟，模拟思考时间和吃饭时间
        int delay = rand() % 5 + 1;
        sleep(delay);
    }

    return NULL;
}

int main(void)
{
    int i;

    for (i = 0; i < N; i++)
    {
        sem_init(&sfork[i], 0, 1);
    }

    sem_init(&waiter, 0, N - 1);
    sem_init(&eatCountMutex, 0, 1);

    pthread_t tid[N];

    for (i = 0; i < N; i++)
    {
        pthread_create(&tid[i], NULL, philosopher, (void *)i);
    }

    for (i = 0; i < N; i++)
    {
        pthread_join(tid[i], NULL);
    }

    for (i = 0; i < N; i++)
    {
        sem_destroy(&sfork[i]);
    }

    sem_destroy(&waiter);
    sem_destroy(&eatCountMutex);

    return 0;
}