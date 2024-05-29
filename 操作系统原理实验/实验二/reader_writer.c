/*
读者线程通过获取mutex信号量和更新readers_count来实现对读者计数的互斥操作。
当读者计数为1时，表示第一个读者到达，获取write_lock写入锁，阻塞写者线程。
读者读取共享数据后，释放mutex信号量，然后根据读者计数是否为0来释放write_lock写入锁，允许写者线程继续执行。

写者线程直接获取write_lock写入锁，写入共享数据后释放该锁。
这样可以保证只有一个写者线程能够写入共享数据，且在写者线程执行期间，不会有读者线程读取共享数据。

在main函数中，首先初始化信号量，然后创建读者线程和写者线程。
最后，使用pthread_join函数等待所有线程结束，并在程序结束时销毁信号量。

添加了readers_completed和writers_completed计数器来跟踪读者和写者的完成次数。
通过在主函数中使用while循环，我们等待所有读者和写者完成任务后才继续执行后续操作，从而限制了读者和写者的次数为3次。
*/

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

#define NUM_READERS 5
#define NUM_WRITERS 2

int shared_data = 0;
int readers_count = 0;
sem_t mutex, write_lock, readers_count_lock;
pthread_t readers[NUM_READERS], writers[NUM_WRITERS];

int readers_completed = 0;
int writers_completed = 0;

void *reader(void *arg)
{
    int reader_id = *((int *)arg);
    int readings = 0;

    while (readings < 3) // 控制读者读取次数
    {
        sem_wait(&readers_count_lock);
        readers_count++;

        if (readers_count == 1)
        {
            sem_wait(&write_lock);
        }

        sem_post(&readers_count_lock);

        // 读
        printf("Reader %d reads data: %d\n", reader_id, shared_data);

        sem_wait(&readers_count_lock);
        readers_count--;

        if (readers_count == 0)
        {
            sem_post(&write_lock);
        }

        sem_post(&readers_count_lock);

        // 睡眠
        usleep(rand() % 1000000);

        readings++;
    }

    // 标记读者完成
    sem_wait(&mutex);
    readers_completed++;
    sem_post(&mutex);

    pthread_exit(NULL);
}

void *writer(void *arg)
{
    int writer_id = *((int *)arg);
    int writings = 0;

    while (writings < 3) // 控制写者写入次数
    {
        sem_wait(&write_lock);

        // 写
        shared_data++;
        printf("Writer %d writes data: %d\n", writer_id, shared_data);

        sem_post(&write_lock);

        // 睡眠
        usleep(rand() % 1000000);

        writings++;
    }

    // 标记写者完成
    sem_wait(&mutex);
    writers_completed++;
    sem_post(&mutex);

    pthread_exit(NULL);
}

int main()
{
    int i, reader_ids[NUM_READERS], writer_ids[NUM_WRITERS];

    // 初始化
    sem_init(&mutex, 0, 1);
    sem_init(&write_lock, 0, 1);
    sem_init(&readers_count_lock, 0, 1);

    // 创建读者进程
    for (i = 0; i < NUM_READERS; i++)
    {
        reader_ids[i] = i + 1;
        pthread_create(&readers[i], NULL, reader, &reader_ids[i]);
    }

    // 创建写者进程
    for (i = 0; i < NUM_WRITERS; i++)
    {
        writer_ids[i] = i + 1;
        pthread_create(&writers[i], NULL, writer, &writer_ids[i]);
    }

    // 等待读结束
    while (readers_completed < NUM_READERS)
    {
        // 等待读者完成
    }

    // 等待写结束
    while (writers_completed < NUM_WRITERS)
    {
        // 等待写者完成
    }

    // 回收信号量
    sem_destroy(&mutex);
    sem_destroy(&write_lock);
    sem_destroy(&readers_count_lock);

    return 0;
}