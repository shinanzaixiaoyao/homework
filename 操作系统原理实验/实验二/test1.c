#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

#define N 10
#define PRODUCER_NUM 10
#define CONSUMER_NUM 10
#define NUM_ITEMS 10

int buffer[N];
int in = 0;
int out = 0;

sem_t full;
sem_t empty;
pthread_mutex_t mutex;

int nextp = 0, nextc = 0;
int items_produced = 0;

void *producer(void *args)
{
    int id = (int)args;
    printf("Producer %d started\n", id);

    while (1)
    {
        pthread_mutex_lock(&mutex);

        if (items_produced >= NUM_ITEMS)
        {
            pthread_mutex_unlock(&mutex);
            break;
        }

        if (((in + 1) % N) == out)
        {
            pthread_mutex_unlock(&mutex);
            continue;
        }

        printf("\033[0;32mProducer %d an item nextp:item_%d\033[0m\n", id, nextp);
        buffer[in] = nextp++;
        in = (in + 1) % N;

        items_produced++;

        pthread_mutex_unlock(&mutex);
        sem_post(&full);

        sleep(3);
    }

    printf("Producer %d ended\n", id);
    pthread_exit(NULL);
}

void *consumer(void *args)
{
    int id = (int)args;
    printf("Consumer %d started\n", id);

    while (1)
    {
        sem_wait(&full);
        pthread_mutex_lock(&mutex);

        if (items_produced >= NUM_ITEMS && in == out)
        {
            pthread_mutex_unlock(&mutex);
            break;
        }

        nextc = buffer[out];
        out = (out + 1) % N;
        printf("\033[0;31mConsumer %d the item in nextc:item_%d\033[0m\n", id, nextc);

        pthread_mutex_unlock(&mutex);
        sem_post(&empty);

        sleep(3);
    }

    printf("Consumer %d ended\n", id);
    pthread_exit(NULL);
}

int main()
{
    int i;
    pthread_t thread[PRODUCER_NUM + CONSUMER_NUM];

    sem_init(&full, 0, 0);
    sem_init(&empty, 0, N);
    pthread_mutex_init(&mutex, NULL);

    for (i = 0; i < PRODUCER_NUM; i++)
    {
        pthread_create(&thread[i], NULL, producer, (void *)i);
    }

    for (i = 0; i < CONSUMER_NUM; i++)
    {
        pthread_create(&thread[PRODUCER_NUM + i], NULL, consumer, (void *)i);
    }

    for (i = 0; i < PRODUCER_NUM + CONSUMER_NUM; i++)
    {
        pthread_join(thread[i], NULL);
    }

    pthread_mutex_destroy(&mutex);
    sem_destroy(&empty);
    sem_destroy(&full);

    return 0;
}