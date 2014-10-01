"""alter db

Revision ID: 46698cf6cd09
Revises: 32a44fa5e09f
Create Date: 2014-10-01 20:59:09.309090

"""

# revision identifiers, used by Alembic.
revision = '46698cf6cd09'
down_revision = '32a44fa5e09f'

from alembic import op
import sqlalchemy as sa


def upgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('account_item', 'item_type')
    op.add_column('fin_transaction', sa.Column('factor', sa.Integer(), nullable=True))
    op.drop_column('service', 'explicit')
    ### end Alembic commands ###


def downgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.add_column('service', sa.Column('explicit', sa.INTEGER(), autoincrement=False, nullable=True))
    op.drop_column('fin_transaction', 'factor')
    op.add_column('account_item', sa.Column('item_type', sa.SMALLINT(), autoincrement=False, nullable=False))
    ### end Alembic commands ###
