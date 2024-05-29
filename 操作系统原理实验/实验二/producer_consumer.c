/*
定义常量：缓冲区大小（BUFFER_SIZE）、生产者数量（PRODUCER_NUM）、消费者数量（CONSUMER_NUM）、要生产的总项数（NUM_ITEMS）。

声明全局变量：缓冲区（buffer）、缓冲区的输入和输出指针（in和out）、
下一个要生产和消费的项（nextp和nextc）、已生产的项数（items_produced）、活动线程计数器（active_threads）。

定义了信号量（sem_t）和互斥锁（pthread_mutex_t）对象，用于线程之间的同步和互斥访问。

实现了生产者线程的函数producer和消费者线程的函数consumer。在这两个函数中，使用了信号量和互斥锁来保证生产者和消费者的正确操作。

在main函数中，进行了信号量和互斥锁的初始化，并创建了多个生产者线程和消费者线程。

在程序的最后，通过一个循环来等待所有线程结束。
只有当所有线程都结束后，循环才会退出，然后程序才会结束。
在循环中，检查活动线程计数器的值，以确定是否还有活动线程。
*/

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

#define N 10
#define BUFFER_SIZE 10
#define PRODUCER_NUM 10
#define CONSUMER_NUM 10
#define NUM_ITEMS 10

int buffer[BUFFER_SIZE];
int in = 0;
int out = 0;

sem_t full;            // 缓冲区已满的信号量
sem_t empty;           // 缓冲区为空的信号量
pthread_mutex_t mutex; // 互斥锁

int nextp = 0, nextc = 0;
int items_produced = 0;
int active_threads = PRODUCER_NUM + CONSUMER_NUM; // 活动线程计数器
int is_producer_done = 0;                         // 生产者是否已经完成生产标志

void *producer(void *args)
{
    int id = (int)args;
    printf("Producer %d started\n", id);

    while (1)
    {
        if (items_produced >= NUM_ITEMS)
        {
            break;
        }

        sem_wait(&empty);           // 等待缓冲区有空闲位置
        pthread_mutex_lock(&mutex); // 加锁，保护缓冲区的访问

        printf("\033[0;32mProducer %d produced item_%d\033[0m\n", id, nextp);
        buffer[in] = nextp++; // 生产一个项并放入缓冲区
        in = (in + 1) % BUFFER_SIZE;

        items_produced++;

        pthread_mutex_unlock(&mutex); // 解锁
        sem_post(&full);              // 增加缓冲区已满的信号量

        sleep(id + 1); // 生产者线程根据其 ID 休眠不同的时间
    }

    printf("Producer %d ended\n", id);

    pthread_mutex_lock(&mutex); // 加锁，更新活动线程计数器
    active_threads--;
    is_producer_done = 1;         // 设置生产者已经完成生产标志
    pthread_mutex_unlock(&mutex); // 解锁

    sem_post(&full); // 唤醒可能还在等待的消费者线程

    pthread_exit(NULL);
}

void *consumer(void *args)
{
    int id = (int)args;
    printf("Consumer %d started\n", id);

    while (1)
    {
        sem_wait(&full);            // 等待缓冲区有数据可取
        pthread_mutex_lock(&mutex); // 加锁，保护缓冲区的访问

        if (items_produced >= NUM_ITEMS && in == out && is_producer_done)
        {
            pthread_mutex_unlock(&mutex); // 解锁
            break;
        }

        nextc = buffer[out]; // 从缓冲区取出一个项
        out = (out + 1) % BUFFER_SIZE;
        printf("\033[0;31mConsumer %d consumed item_%d\033[0m\n", id, nextc);

        pthread_mutex_unlock(&mutex); // 解锁
        sem_post(&empty);             // 增加缓冲区为空的信号量

        sleep(1); // 消费者线程休眠
    }

    printf("Consumer %d ended\n", id);

    pthread_exit(NULL);
}

int main()
{
    pthread_t producers[PRODUCER_NUM];
    pthread_t consumers[CONSUMER_NUM];

    sem_init(&full, 0, 0);
    sem_init(&empty, 0, BUFFER_SIZE);
    pthread_mutex_init(&mutex, NULL);
    int i = 0;

    for (i = 0; i < PRODUCER_NUM; i++)
    {
        pthread_create(&producers[i], NULL, producer, (void *)i);
    }

    for (i = 0; i < CONSUMER_NUM; i++)
    {
        pthread_create(&consumers[i], NULL, consumer, (void *)i);
    }

    for (i = 0; i < PRODUCER_NUM; i++)
    {
        pthread_join(producers[i], NULL);
    }

    for (i = 0; i < CONSUMER_NUM; i++)
    {
        pthread_join(consumers[i], NULL);
    }

    sem_destroy(&full);
    sem_destroy(&empty);
    pthread_mutex_destroy(&mutex);

    return 0;
}